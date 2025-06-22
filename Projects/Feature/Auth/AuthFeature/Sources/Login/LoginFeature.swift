//
//  LoginFeature.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct LoginFeature {
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case closeButtonTapped
    
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case dismiss
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .closeButtonTapped:
        return .send(.delegate(.dismiss))
        
      default: return .none
      }
    }
  }
}
