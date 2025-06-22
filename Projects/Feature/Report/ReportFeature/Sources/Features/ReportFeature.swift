//
//  ReportFeature.swift
//
//  Report
//
//  Created by yongin
//

import ComposableArchitecture

@Reducer
public struct ReportFeature {
  
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    var moveLocation: MoveLocationFeature.State = MoveLocationFeature.State()
    var writeName: WriteNameFeature.State = WriteNameFeature.State()
    var selectKind: SelectKindFeature.State = SelectKindFeature.State()
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case moveLocation(MoveLocationFeature.Action)
    case writeName(WriteNameFeature.Action)
    case selectKind(SelectKindFeature.Action)
    case binding(BindingAction<State>)
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
        default: return .none
      }
    }
  }
}
