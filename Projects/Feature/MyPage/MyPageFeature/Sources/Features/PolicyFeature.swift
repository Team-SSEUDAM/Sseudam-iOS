//
//  PolicyFeature.swift
//  MyPageFeature
//
//  Created by Jiyeon on 8/16/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct PolicyFeature {
  
  public init() { }
  
  @ObservableState
  public struct State: Equatable {
    var type: PolicyType? = nil
    
    public init(type: PolicyType? = nil) {
      self.type = type
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case pop
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case pop
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .pop:
        return .send(.delegate(.pop))
      default: return .none
      }
    }
  }
}
