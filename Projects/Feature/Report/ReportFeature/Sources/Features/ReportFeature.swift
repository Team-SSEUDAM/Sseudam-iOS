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
    /// 현재 페이지 인덱스 (0: 시작화면, 1: 위치 선택, 2: 이름 작성, 3: 종류 선택, 4: 사진 촬영)
    var currentPage: Int = 0
    /// 1번 화면인 `MoveLocationFeature`의 상태
    var moveLocation: MoveLocationFeature.State = MoveLocationFeature.State()
    /// 2번 화면인 `WriteNameFeature`의 상태
    var writeName: WriteNameFeature.State = WriteNameFeature.State()
    /// 3번 화면인 `SelectKindFeature`의 상태
    var selectKind: SelectKindFeature.State = SelectKindFeature.State()
    
    /// `nextButton`의 활성화 여부
    var nextButtonState: PrimaryButtonState = .normal
    /// `nextButton`의 텍스트 (`시작하기`, `다음`, `확인`)
    var nextButtonText: String = "시작하기"
    
    var reportModel: ReportBody = ReportBody()
    
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case moveLocation(MoveLocationFeature.Action)
    case writeName(WriteNameFeature.Action)
    case selectKind(SelectKindFeature.Action)
    case binding(BindingAction<State>)
    
    /// 시작 화면이 나타날 때
    case didAppearStartReport(Int)
    /// 위치 선택 화면이 나타날 때
    case didAppearMoveLocation(Int)
    /// 이름 작성 화면이 나타날 때
    case didAppearWriteName(Int)
    /// 종류 선택 화면이 나타날 때
    case didAppearSelectKind(Int)
    
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
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        switch state.currentPage {
        case 0: return .send(.pop) /// RecordFeature에서 처리
        default: return .send(.backPageTapped)
        }
      case .backPageTapped:
        let oldValue = state.currentPage
        state.currentPage = max(state.currentPage - 1, 0)
        switch state.currentPage {
        case 0: return .send(.didAppearStartReport(oldValue))
        case 1: return .send(.didAppearMoveLocation(oldValue))
        case 2: return .send(.didAppearWriteName(oldValue))
        case 3: return .send(.didAppearSelectKind(oldValue))
        default: return .none
        }
      case .nextButtonTapped:
        let oldValue = state.currentPage
        state.currentPage = min(state.currentPage + 1, 3)
        switch state.currentPage {
        case 0: return .send(.didAppearStartReport(oldValue))
        case 1: return .send(.didAppearMoveLocation(oldValue))
        case 2: return .send(.didAppearWriteName(oldValue))
        case 3: return .send(.didAppearSelectKind(oldValue))
        default: return .none
        }
      case let .nextButtonIsEnabled(isEnabled):
        state.nextButtonState = isEnabled ? .normal : .disabled
        print("nextButtonState: \(state.nextButtonState)")
        return .none
      case let .didAppearStartReport(prevPage):
        state.nextButtonText = "시작하기"
        return .send(.nextButtonIsEnabled(true))
      case let .didAppearMoveLocation(prevPage):
        state.nextButtonText = "다음"
        return .merge([
          .send(.writeName(.injectedFocus(false))),
          .send(.nextButtonIsEnabled(state.moveLocation.isEnabled))
        ])
      case let .didAppearWriteName(prevPage):
        state.nextButtonText = "다음"
        return .merge([
          .send(.writeName(.injectedFocus(true))),
          .send(.nextButtonIsEnabled(state.writeName.isEnabled))
        ])
      case let .didAppearSelectKind(prevPage):
        let needToMakeEnabled = prevPage > state.currentPage
        state.nextButtonText = "다음"
        return .send(.nextButtonIsEnabled(needToMakeEnabled))
      /// `MoveLocationFeature`의 `Delegate`처리
      case let .moveLocation(.delegate(action)):
        switch action {
        case let .centerChanged(location):
          state.reportModel.location = location
          return .send(.nextButtonIsEnabled(true))
        }
      /// `WriteNameFeature`의 `Delegate`처리
      case let .writeName(.delegate(action)):
        switch action {
        case let .nameChanged(name):
          state.reportModel.name = name
          return .send(.nextButtonIsEnabled(!name.isEmpty))
        }
      case .binding:
        return .none
        default: return .none
      }
    }
  }
}
