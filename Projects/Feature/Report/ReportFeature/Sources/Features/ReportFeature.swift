//
//  ReportFeature.swift
//
//  Report
//
//  Created by yongin
//

import ComposableArchitecture
import ReportDomainInterface
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
    
    var reportModel: ReportBody = ReportBody()
    
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    
    @CasePathable
    public enum PhotoConfirmationDialog: Equatable {
      case takePhotoButtonTapped
      case selectPhotoButtonTapped
      case selectPhotoFromLibraryButtonTapped
    }
    
    case destination(PresentationAction<Destination.Action>)
    
    case moveLocation(MoveLocationFeature.Action)
    case writeName(WriteNameFeature.Action)
    case selectKind(SelectKindFeature.Action)
    case selectPhoto(SelectPhotoFeature.Action)
    case binding(BindingAction<State>)
    
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
    
    case willAppearPhotoConfirmationDialog
    
    case nextButtonIsEnabled(Bool)
    case nextButtonTapped
    
    case backButtonTapped
    case pop
    case backPageTapped
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.moveLocation, action: \.moveLocation) { MoveLocationFeature() }
    Scope(state: \.writeName, action: \.writeName) { WriteNameFeature() }
    Scope(state: \.selectKind, action: \.selectKind) { SelectKindFeature() }
    Scope(state: \.selectPhoto, action: \.selectPhoto) { SelectPhotoFeature() }
    Reduce { state, action in
      print("😢 ReportFeature Action: \(action)")
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
        case let .centerChanged(location):
          state.reportModel.location = location
          return .send(.nextButtonIsEnabled(true))
        }
      /// `WriteNameFeature`의 `Delegate`처리
      case let .writeName(.delegate(action)):
        if state.currentPage != 2 { return .none }
        switch action {
        case let .nameChanged(name):
          state.reportModel.name = name
          return .send(.nextButtonIsEnabled(!name.isEmpty))
        }
      /// `SelectKindFeature`의 `Delegate`처리
      case let .selectKind(.delegate(action)):
        if state.currentPage != 3 { return .none }
        switch action {
        case let .didSelectKind(kind):
          state.reportModel.kind = kind
          return .send(.nextButtonIsEnabled(true))
        }
      /// `SelectPhotoFeature`의 `Delegate`처리
      case let .selectPhoto(.delegate(action)):
        if state.currentPage != 4 { return .none }
        switch action {
        case .selectPhotoButtonTapped:
          return .send(.willAppearPhotoConfirmationDialog)
        }
        
      /// - 바텀 다이얼로그 관련 action 처리
      case .willAppearPhotoConfirmationDialog:
        state.destination = .confirmationDialog(.makePhotoConfirmationDialog)
        return .none
      case .destination(.presented(.confirmationDialog(.takePhotoButtonTapped))):
        state.destination = nil /// 다이얼로그 제거
        // TODO: - 사진 찍기 관련 로직 구현 및 action 전달
        return .none
      case .destination(.presented(.confirmationDialog(.selectPhotoButtonTapped))):
        state.destination = nil /// 다이얼로그 제거
        // TODO: - 앨범 사진 선택 관련 로직 구현 및 action 전달
        return .none
      case .destination(.presented(.confirmationDialog(.selectPhotoFromLibraryButtonTapped))):
        state.destination = nil /// 다이얼로그 제거
        // TODO: - 파일에서 사진 선택 관련 로직 구현 및 action 전달
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

extension ReportFeature {
  @Reducer
  public enum Destination: Equatable {
    case addCompleteReport
    case confirmationDialog(ConfirmationDialogState<ReportFeature.Action.PhotoConfirmationDialog>)
  }
}

extension ReportFeature.Destination.Action: Equatable { }
extension ReportFeature.Destination.State: Equatable { }

extension ConfirmationDialogState where Action == ReportFeature.Action.PhotoConfirmationDialog {
  public static let makePhotoConfirmationDialog = Self {
    TextState("")
  } actions: {
    ButtonState(action: .takePhotoButtonTapped) { TextState("사진 찍기") }
    ButtonState(action: .selectPhotoButtonTapped) { TextState("사진 보관함에서 선택") }
    ButtonState(action: .selectPhotoFromLibraryButtonTapped) { TextState("파일에서 선택") }
    ButtonState(role: .cancel) { TextState("취소") }
  }
}
