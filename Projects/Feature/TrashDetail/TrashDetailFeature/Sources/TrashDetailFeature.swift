//
//  TrashDetailFeature.swift
//
//  TrashDetail
//
//  Created by JiYeon
//

import ComposableArchitecture

@Reducer
public struct TrashDetailFeature {
  
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        default: return .none
      }
    }
  }
}
