//
//  SettingFeature.swift
//  MyPageFeature
//
//  Created by Jiyeon on 7/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct SettingFeature {
  
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    var isLoggedIn: Bool = true
    var isNotiOn: Bool = true
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case pop
    case delegate(Delegate)
  }
  
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    
  }
  
  public enum Delegate: Equatable {
    case pop
  }
  
  @Dependency(\.dismiss) var dismiss

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

