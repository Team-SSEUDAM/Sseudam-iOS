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
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case moveLocation(MoveLocationFeature.Action)
    case binding(BindingAction<State>)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.moveLocation, action: \.moveLocation) {
      MoveLocationFeature()
    }
    Reduce { state, action in
      switch action {
        default: return .none
      }
    }
  }
}
