//
//  ReportFeature.swift
//
//  Report
//
//  Created by yongin
//

import ComposableArchitecture
import DesignKit

@Reducer
public struct ReportFeature {
  
  public init() {
    
  }
  
  public enum BackActionType {
    case pop
    case backToScroll
  }
  
  @ObservableState
  public struct State: Equatable {
    var moveLocation: MoveLocationFeature.State = MoveLocationFeature.State()
    var writeName: WriteNameFeature.State = WriteNameFeature.State()
    var selectKind: SelectKindFeature.State = SelectKindFeature.State()
    
    /// 초기화면: `.pop` | 이후 화면 플로우: `.backToScroll`
    var backActionType: BackActionType = .pop
    /// `nextButton`의 활성화 여부
    var nextButtonState: PrimaryButtonState = .normal
    /// `nextButton`의 텍스트 (`시작하기`, `다음`, `확인`)
    var nextButtonText: String = "시작하기"
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case moveLocation(MoveLocationFeature.Action)
    case writeName(WriteNameFeature.Action)
    case selectKind(SelectKindFeature.Action)
    case binding(BindingAction<State>)
    
    case backButtonTapped(BackActionType)
    case pop
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.moveLocation, action: \.moveLocation) {
      MoveLocationFeature()
    }
    Scope(state: \.writeName, action: \.writeName) {
      WriteNameFeature()
    }
    Scope(state: \.selectKind, action: \.selectKind) {
      SelectKindFeature()
    }
    Reduce { state, action in
      switch action {
      case let .backButtonTapped(type):
        switch type {
        case .pop:
          return .send(.pop)
        case .backToScroll:
          // TODO: 현재 Scroll의 ContentOffset에 따라서, 이전 화면으로 offset을 조정해야 함
          return .none
        }
        default: return .none
      }
    }
  }
}
