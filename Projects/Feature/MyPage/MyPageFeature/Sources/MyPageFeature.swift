//
//  MyPageFeature.swift
//
//  MyPage
//
//  Created by Jiyeon
//

import ComposableArchitecture

@Reducer
public struct MyPageFeature {
  
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
