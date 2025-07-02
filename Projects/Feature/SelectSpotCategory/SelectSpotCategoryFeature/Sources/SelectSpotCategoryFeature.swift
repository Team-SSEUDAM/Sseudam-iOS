//
//  SelectSpotCategoryFeature.swift
//
//  SelectSpotCategory
//
//  Created by yongin
//

import ComposableArchitecture

@Reducer
public struct SelectSpotCategoryFeature {
  
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
