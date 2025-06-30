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
import UserDefaults

@Reducer
struct MyPageRootFeature {
  @ObservableState
  struct State {
    var isLoggedIn: Bool
    
    init() {
      self.isLoggedIn = UserDefaultsKeys.isLoggedIn ?? false
    }
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case loginState(Bool)
    case delegate(Delegate)
    
    case requestLogin(Bool, AuthEntryPoint)
    
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
      case let .loginState(isLoggedIn):
        state.isLoggedIn = isLoggedIn
        return .none
      default: return .none
      }
      
    }
    
  }
  
  
}
