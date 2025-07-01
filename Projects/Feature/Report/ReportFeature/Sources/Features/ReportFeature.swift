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
    var isNavigationBarHidden = false
    
    var selectedPhoto: UIImage? = nil
    
    /// 서버 검증 관련 상태
    var isServerValidating: Bool = false
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
    /// 제보가 완료되었을 때
    case didAppearComplete
    
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
        /// 다음 페이지로 넘어가기 전에 현재 페이지에서 검증 action
        if state.currentPage == 2 { return .send(.writeName(.validateNameFromServer)) }
        if state.currentPage == 5 { return .send(.pop) }
        state.currentPage = min(state.currentPage + 1, 5)
        /// 다음 페이지에 따라 적절한 action을 보냄
        switch state.currentPage {
        case 0: return .send(.didAppearStartReport)
        case 1: return .send(.didAppearMoveLocation)
        case 2: return .send(.didAppearWriteName)
        case 3: return .send(.didAppearSelectKind)
        case 4: return .send(.didAppearSelectPhoto)
        case 5: return .send(.didAppearComplete)
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
          .send(.writeName(.focusChanged(false))),
          .send(.nextButtonIsEnabled(state.moveLocation.isEnabled))
        ])
      case .didAppearWriteName:
        state.nextButtonText = "다음"
        return .merge([
          .send(.writeName(.focusChanged(true))),
          .send(.nextButtonIsEnabled(state.writeName.isButtonEnabled))
        ])
      case .didAppearSelectKind:
        state.nextButtonText = "다음"
        return .merge([
          .send(.writeName(.focusChanged(false))),
          .send(.nextButtonIsEnabled(state.selectKind.isEnabled))
        ])
      case .didAppearSelectPhoto:
        state.nextButtonText = "완료"
        return .merge([
          .send(.nextButtonIsEnabled(state.selectPhoto.isEnabled))
        ])
      case .didAppearComplete:
        state.isNavigationBarHidden = true
        state.nextButtonText = "확인"
        return .send(.nextButtonIsEnabled(true))
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
        case let .nameValidationChanged(isValid, name):
          state.spotName = name
          state.isServerValidating = false
          return .send(.nextButtonIsEnabled(isValid && !state.isServerValidating))
        case let .serverValidationCompleted(isValid, name):
          state.spotName = name
          state.isServerValidating = false
          if isValid {
            state.currentPage = min(state.currentPage + 1, 4)
            return .send(.didAppearSelectKind)
          } else {
            return .send(.nextButtonIsEnabled(false))
          }
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
          state.selectedPhoto = photo
          return .send(.nextButtonIsEnabled(true))
        }
        /// 서버 검증 시작 시 버튼 상태 업데이트
      case .writeName(.validateNameFromServer):
        if state.currentPage == 2 {
          state.isServerValidating = true
          return .send(.nextButtonIsEnabled(false))
        }
        return .none
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
          return .send(.nextButtonTapped) /// 완료 페이지로 이동
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
    .ifLet(\.$destination, action: \.destination) {
      Destination.body
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
