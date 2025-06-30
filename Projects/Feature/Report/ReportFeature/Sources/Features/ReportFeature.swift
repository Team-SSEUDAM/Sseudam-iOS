//
//  ReportFeature.swift
//
//  Report
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture
import Utility
import NMReverseGeocodingDomainInterface
import SuggestionDomainInterface
import DesignKit

@Reducer
public struct ReportFeature {
  
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    @Presents var destination: Destination.State?
    
    var currentPage: Int = 0
    var moveLocation: MoveLocationFeature.State = MoveLocationFeature.State()
    var writeName: WriteNameFeature.State = WriteNameFeature.State()
    var selectKind: SelectKindFeature.State = SelectKindFeature.State()
    var selectPhoto: SelectPhotoFeature.State = SelectPhotoFeature.State()
    
    var nextButtonState: PrimaryButtonState = .normal
    var nextButtonText: String = "시작하기"
    
    /// 제보하기에 담길 데이터
    var spotName: String = ""
    var centerPoint: Coordinates?
    var nmReverseGeoCodeEntity: NMGeoCodeReverseEntity?
    var trashType: String = ""
    
    var selectedPhoto: UIImage? = nil
    
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    @CasePathable
    public enum Alert: Equatable { }
    
    case destination(PresentationAction<Destination.Action>)
    
    case moveLocation(MoveLocationFeature.Action)
    case writeName(WriteNameFeature.Action)
    case selectKind(SelectKindFeature.Action)
    case selectPhoto(SelectPhotoFeature.Action)
    case binding(BindingAction<State>)
    
    case spotSuggestionResult(Result<String, NetworkError>)
    case uploadSpotImageResult(Result<String, NetworkError>)
    case postSpotImage(String)
    
    case errorOccured(message: String)
    
    /// 시작 화면이 나타날 때
    case didAppearStartReport
    /// 위치 선택 화면이 나타날 때
    case didAppearMoveLocation
    /// 이름 작성 화면이 나타날 때
    case didAppearWriteName
    /// 종류 선택 화면이 나타날 때
    case didAppearSelectKind
    /// 사진 선택 화면이 나타날 때
    case didAppearSelectPhoto
    
    case nextButtonIsEnabled(Bool)
    case nextButtonTapped
    case reportButtonTapped
    
    case backButtonTapped
    case pop
    case backPageTapped
  }
  
  @Dependency(\.SpotSuggestionUseCase) var spotSuggestionUseCase
  @Dependency(\.UploadSpotImageUseCase) var uploadSpotImageUseCase

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.moveLocation, action: \.moveLocation) { MoveLocationFeature() }
    Scope(state: \.writeName, action: \.writeName) { WriteNameFeature() }
    Scope(state: \.selectKind, action: \.selectKind) { SelectKindFeature() }
    Scope(state: \.selectPhoto, action: \.selectPhoto) { SelectPhotoFeature() }
    Reduce {
      state,
      action in
      switch action {
      case .backButtonTapped:
        switch state.currentPage {
        case 0: return .send(.pop) /// RecordFeature에서 처리
        default: return .send(.backPageTapped)
        }
      case .backPageTapped:
        state.currentPage = max(state.currentPage - 1, 0)
        switch state.currentPage {
        case 0: return .send(.didAppearStartReport)
        case 1: return .send(.didAppearMoveLocation)
        case 2: return .send(.didAppearWriteName)
        case 3: return .send(.didAppearSelectKind)
        case 4: return .send(.didAppearSelectPhoto)
        default: return .none
        }
      case .nextButtonTapped:
        if state.currentPage == 4 { return .send(.reportButtonTapped) }
        state.currentPage = min(state.currentPage + 1, 4)
        switch state.currentPage {
        case 0: return .send(.didAppearStartReport)
        case 1: return .send(.didAppearMoveLocation)
        case 2: return .send(.didAppearWriteName)
        case 3: return .send(.didAppearSelectKind)
        case 4: return .send(.didAppearSelectPhoto)
        default: return .none
        }
      case let .nextButtonIsEnabled(isEnabled):
        state.nextButtonState = isEnabled ? .normal : .disabled
        return .none
      case .didAppearStartReport:
        state.nextButtonText = "시작하기"
        return .send(.nextButtonIsEnabled(true))
      case .didAppearMoveLocation:
        state.nextButtonText = "다음"
        return .merge([
          .send(.writeName(.injectedFocus(false))),
          .send(.nextButtonIsEnabled(state.moveLocation.isEnabled))
        ])
      case .didAppearWriteName:
        state.nextButtonText = "다음"
        return .merge([
          .send(.writeName(.injectedFocus(true))),
          .send(.nextButtonIsEnabled(state.writeName.isEnabled))
        ])
      case .didAppearSelectKind:
        state.nextButtonText = "다음"
        return .merge([
          .send(.writeName(.injectedFocus(false))),
          .send(.nextButtonIsEnabled(state.selectKind.isEnabled))
        ])
      case .didAppearSelectPhoto:
        state.nextButtonText = "제보하기"
        return .merge([
          .send(.nextButtonIsEnabled(state.selectPhoto.isEnabled))
        ])
        /// `MoveLocationFeature`의 `Delegate`처리
      case let .moveLocation(.delegate(action)):
        if state.currentPage != 1 { return .none }
        switch action {
        case let .centerChanged(location, entity):
          state.centerPoint = location
          state.nmReverseGeoCodeEntity = entity
          return .send(.nextButtonIsEnabled(location != nil && entity != nil))
        }
        /// `WriteNameFeature`의 `Delegate`처리
      case let .writeName(.delegate(action)):
        if state.currentPage != 2 { return .none }
        switch action {
        case let .nameChanged(spotName):
          state.spotName = spotName
          return .send(.nextButtonIsEnabled(!spotName.isEmpty))
        }
        /// `SelectKindFeature`의 `Delegate`처리
      case let .selectKind(.delegate(action)):
        if state.currentPage != 3 { return .none }
        switch action {
        case let .didSelectKind(trashType):
          state.trashType = trashType
          return .send(.nextButtonIsEnabled(true))
        }
        /// `SelectPhotoFeature`의 `Delegate`처리
      case let .selectPhoto(.delegate(action)):
        if state.currentPage != 4 { return .none }
        switch action {
        case let .photoSelected(photo):
          print("Photo Size: \(photo.size)")
          state.selectedPhoto = photo /// 사진은, 일반적인 ReportBody에 담지 않고, presignedURL로 별도 처리
          return .send(.nextButtonIsEnabled(true))
        }
      case .reportButtonTapped:
        return spotSuggestionEffect(state: state, useCase: spotSuggestionUseCase)
      case let .postSpotImage(prisignedURL):
        return uploadSpotImageEffect(state, prisignedURL, uploadSpotImageUseCase)
      case let .spotSuggestionResult(result):
        switch result {
        case let .success(prisignedURL):
          return .send(.postSpotImage(prisignedURL))
        case let .failure(error):
          return .send(.errorOccured(message: error.localizedDescription))
        }
      case let .uploadSpotImageResult(result):
        switch result {
        case .success:
          return .send(.pop)
        case let .failure(error):
          return .send(.errorOccured(message: error.localizedDescription))
        }
      case let .errorOccured(message):
        state.destination = .alert(.occuredError(message))
        return .none
      case .destination(.dismiss):
        state.destination = nil
        return .none
      case .binding:
        return .none
        default: return .none
      }
    }
  }
}

public extension ReportFeature {
  func spotSuggestionEffect(
    state: Self.State,
    useCase: SpotSuggestionUseCase
  ) -> Effect<Action> {
    .run { send in
      do {
        let entity = try await useCase.execute(
          state.spotName,
          state.centerPoint,
          state.nmReverseGeoCodeEntity,
          state.trashType
        )
        await send(.spotSuggestionResult(.success(entity)))
      } catch is CancellationError {
        await send(.spotSuggestionResult(.failure(.taskCancelled)))
      } catch {
        await send(.spotSuggestionResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
  
  func uploadSpotImageEffect(
    _ state: Self.State,
    _ url: String,
    _ useCase: UploadSpotImageUseCase
  ) -> Effect<Action> {
    .run { send in
      do {
        guard let image = state.selectedPhoto else {
          throw NetworkError.customError(message: "이미지를 선택해주세요.")
        }
        try await useCase.execute(image, url)
        await send(.uploadSpotImageResult(.success("성공"))) /// 임시 메시지
      } catch is CancellationError {
        await send(.uploadSpotImageResult(.failure(.taskCancelled)))
      } catch {
        await send(.uploadSpotImageResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }

}

extension ReportFeature {
  @Reducer(state: .equatable, action: .equatable)
  public enum Destination {
    case alert(AlertState<ReportFeature.Action.Alert>)
  }
}


extension AlertState where Action == ReportFeature.Action.Alert {
  static func occuredError(_ message: String) -> Self {
    Self {
      TextState("제보하기 도중에 오류가 발생했습니다.")
    } message: {
      TextState(message)
    }
  }
}
