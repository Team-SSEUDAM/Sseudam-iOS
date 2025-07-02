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

import SelectSpotCategoryFeature

import DesignKit

@Reducer
public struct ReportFeature {
  
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    @Presents var destination: Destination.State?
    
    var currentPage: Int = 0
    
    /// 각 페이지별 상태를 Child로 관리
    var child: Child.State = Child.State()
    
    var nextButtonState: PrimaryButtonState = .normal
    var nextButtonText: String = "시작하기"
    var isLoading: Bool = false /// 다음 버튼의 로딩 상태
    
    /// 제보하기에 담길 데이터
    var spotName: String = ""
    var centerPoint: Coordinates?
    var nmReverseGeoCodeEntity: NMGeoCodeReverseEntity?
    var trashType: String = ""
    var isNavigationBarHidden = false
    
    var selectedPhoto: UIImage? = nil
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    @CasePathable
    public enum Alert: Equatable { }
    
    case destination(PresentationAction<Destination.Action>)
    case child(Child.Action)
    case binding(BindingAction<State>)
    
    
    case spotSuggestionResult(Result<String, NetworkError>)
    case uploadSpotImageResult(Result<String, NetworkError>)
    case postSpotImage(String)
    
    case setIsLoading(Bool)
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
    case validateSpotNameButtonTapped /// 이름 작성 화면에서, 서버검증 요청
    case reportButtonTapped /// 제보하기 화면에서, 서버 검증 요청
    
    
    case backButtonTapped
    case pop
    case backPageTapped
  }
  
  @Dependency(\.SpotSuggestionUseCase) var spotSuggestionUseCase
  @Dependency(\.UploadSpotImageUseCase) var uploadSpotImageUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    // Child를 하나의 Scope로 관리
    Scope(state: \.child, action: \.child) {
      Child()
    }
    
    Reduce { state, action in
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
        if state.currentPage == 2 { return .send(.validateSpotNameButtonTapped) }
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
          .send(.child(.writeName(.focusChanged(false)))),
          .send(.nextButtonIsEnabled(state.child.moveLocation.isEnabled))
        ])
        
      case .didAppearWriteName:
        state.nextButtonText = "다음"
        return .merge([
          .send(.child(.writeName(.focusChanged(true)))),
          .send(.nextButtonIsEnabled(state.child.writeName.isButtonEnabled))
        ])
        
      case .didAppearSelectKind:
        state.nextButtonText = "다음"
        return .merge([
          .send(.child(.writeName(.focusChanged(false)))),
          .send(.nextButtonIsEnabled(state.child.selectKind.isEnabled))
        ])
        
      case .didAppearSelectPhoto:
        state.nextButtonText = "완료"
        return .merge([
          .send(.nextButtonIsEnabled(state.child.selectPhoto.isEnabled))
        ])
        
      case .didAppearComplete:
        state.isNavigationBarHidden = true
        state.nextButtonText = "확인"
        return .run { send in
          await send(.nextButtonIsEnabled(true))
          await send(.setIsLoading(false))
        }
        
        /// Child에서 오는 Delegate 처리
      case let .child(.delegate(delegateAction)):
        switch delegateAction {
        case let .moveLocation(action): return handleMoveLocationDelegate(state: &state, action: action)
        case let .writeName(action): return handleWriteNameDelegate(state: &state, action: action)
        case let .selectKind(action): return handleSelectKindDelegate(state: &state, action: action)
        case let .selectPhoto(action): return handleSelectPhotoDelegate(state: &state, action: action)
        }
        
        // Child의 일반 Action들 처리 (delegate가 아닌 경우)
      case .child(.moveLocation):
        return .none
        
      case .child(.writeName):
        return .none
        
      case .child(.selectKind):
        return .none
        
      case .child(.selectPhoto):
        return .none
        
      case .validateSpotNameButtonTapped:
        return .run { send in
          await send(.setIsLoading(true))
          await send(.child(.writeName(.validateNameFromServer)))
        }
        
      case .reportButtonTapped:
        return spotSuggestionEffect(state, spotSuggestionUseCase)
        
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
        return .send(.setIsLoading(false))
        
      case let .setIsLoading(isLoading):
        state.nextButtonState = isLoading ? .loading : state.nextButtonState
        state.isLoading = isLoading
        return .none
        
      case .destination(.dismiss):
        state.destination = nil
        return .none
        
      case .destination:
        return .none
        
      case .binding:
        return .none
        
      case .pop:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination.body
    }
  }
}

// MARK: - Child Reducer
@Reducer
public struct Child {
  
  @ObservableState
  public struct State: Equatable {
    var moveLocation: MoveLocationFeature.State = MoveLocationFeature.State()
    var writeName: WriteNameFeature.State = WriteNameFeature.State()
    var selectKind: SelectSpotCategoryFeature.State = SelectSpotCategoryFeature.State()
    var selectPhoto: SelectPhotoFeature.State = SelectPhotoFeature.State()
    
    public init() {}
  }
  
  public enum Action: Equatable {
    case moveLocation(MoveLocationFeature.Action)
    case writeName(WriteNameFeature.Action)
    case selectKind(SelectSpotCategoryFeature.Action)
    case selectPhoto(SelectPhotoFeature.Action)
    case delegate(Delegate)
    
    @CasePathable
    public enum Delegate: Equatable {
      case moveLocation(MoveLocationFeature.Action.Delegate)
      case writeName(WriteNameFeature.Action.Delegate)
      case selectKind(SelectSpotCategoryFeature.Action.Delegate)
      case selectPhoto(SelectPhotoFeature.Action.Delegate)
    }
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.moveLocation, action: \.moveLocation) {
      MoveLocationFeature()
    }
    Scope(state: \.writeName, action: \.writeName) {
      WriteNameFeature()
    }
    Scope(state: \.selectKind, action: \.selectKind) {
      SelectSpotCategoryFeature()
    }
    Scope(state: \.selectPhoto, action: \.selectPhoto) {
      SelectPhotoFeature()
    }
    
    Reduce { state, action in
      switch action {
        /// MoveLocationFeature의 delegate를 부모로 전달
      case let .moveLocation(.delegate(delegateAction)):
        return .send(.delegate(.moveLocation(delegateAction)))
        
        /// WriteNameFeature의 delegate를 부모로 전달
      case let .writeName(.delegate(delegateAction)):
        return .send(.delegate(.writeName(delegateAction)))
        
        /// SelectKindFeature의 delegate를 부모로 전달
      case let .selectKind(.delegate(delegateAction)):
        return .send(.delegate(.selectKind(delegateAction)))
        
        /// SelectPhotoFeature의 delegate를 부모로 전달
      case let .selectPhoto(.delegate(delegateAction)):
        return .send(.delegate(.selectPhoto(delegateAction)))
        
        /// 일반 Action들은 각각의 Scope에서 처리되므로 여기서는 패스
      case .moveLocation:
        return .none
        
      case .writeName:
        return .none
        
      case .selectKind:
        return .none
        
      case .selectPhoto:
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
}

// MARK: - Delegate Handlers
private extension ReportFeature {
  
  /// `MoveLocationFeature` Delegate 처리
  func handleMoveLocationDelegate(
    state: inout State,
    action: MoveLocationFeature.Action.Delegate
  ) -> Effect<Action> {
    guard state.currentPage == 1 else { return .none }
    
    switch action {
    case let .nowCalculateReverseGeoCode(isLoading):
      return .send(.setIsLoading(isLoading))
      
    case let .centerChanged(location, entity):
      state.centerPoint = location
      state.nmReverseGeoCodeEntity = entity
      return .send(.nextButtonIsEnabled(location != nil && entity != nil))
    }
  }
  
  /// `WriteNameFeature(쓰레기통 이름 작성)` Delegate 처리
  func handleWriteNameDelegate(
    state: inout State,
    action: WriteNameFeature.Action.Delegate
  ) -> Effect<Action> {
    guard state.currentPage == 2 else { return .none }
    
    switch action {
    case let .localValidationCompleted(isValid, name):
      state.spotName = name
      return .send(.nextButtonIsEnabled(isValid))
      
    case let .serverValidationCompleted(isValid, name):
      state.spotName = name
      if isValid {
        state.currentPage = 3
        return .run { send in
          await send(.setIsLoading(false))
          await send(.didAppearSelectKind)
        }
      } else {
        return .run { send in
          await send(.setIsLoading(false))
          await send(.nextButtonIsEnabled(false))
        }
      }
    }
  }
  
  /// `SelectSpotCategoryFeature(쓰레기 종류 선택)` Delegate 처리
  func handleSelectKindDelegate(
    state: inout State,
    action: SelectSpotCategoryFeature.Action.Delegate
  ) -> Effect<Action> {
    guard state.currentPage == 3 else { return .none }
    
    switch action {
    case let .didSelectKind(trashType):
      state.trashType = trashType
      return .send(.nextButtonIsEnabled(true))
    }
  }
  
  /// `SelectPhotoFeature(사진 선택)` Delegate 처리
  func handleSelectPhotoDelegate(
    state: inout State,
    action: SelectPhotoFeature.Action.Delegate
  ) -> Effect<Action> {
    guard state.currentPage == 4 else { return .none }
    
    switch action {
    case let .photoSelected(photo):
      state.selectedPhoto = photo
      return .send(.nextButtonIsEnabled(true))
    }
  }
}

/// MARK: - 순수하게 `ReportFeature`에서 사용할 `Effect들
public extension ReportFeature {
  func spotSuggestionEffect(
    _ state: Self.State,
    _ useCase: SpotSuggestionUseCase
  ) -> Effect<Action> {
    .run { send in
      do {
        await send(.setIsLoading(true))
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
