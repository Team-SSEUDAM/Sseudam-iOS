//
//  MyPageRootFeature.swift
//  Sseudam
//
//  Created by Jiyeon on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import AuthFeature

@Reducer
struct MyPageRootFeature {
  @ObservableState
  struct State {
    var auth: AuthFeature.State? = nil
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case delegate(Delegate)
    
    case requestLogin(Bool, AuthEntryPoint)
    case auth(AuthFeature.Action)
  }
  
  enum Delegate: Equatable {
    case hiddenTabBar(Bool)
    case requestLogin(Bool, AuthEntryPoint)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .requestLogin(isPresent, entryPoint):
        return .send(.delegate(.requestLogin(isPresent, entryPoint)))
      default: return .none
      }
      
    }
    .ifLet(\.auth, action: \.auth ) {
      AuthFeature()
    }
  }
  
  
}
