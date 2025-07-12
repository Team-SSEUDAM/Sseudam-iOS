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
import MyPageFeature

@Reducer
struct MyPageRootFeature {
  @ObservableState
  struct State {
    var mypage: MyPageFeature.State = .init()
    init() { }
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case delegate(Delegate)
    
    case requestLogin(Bool, AuthEntryPoint)
    case mypage(MyPageFeature.Action)
  }
  
  enum Delegate: Equatable {
    case hiddenTabBar(Bool)
    case requestLogin(Bool, AuthEntryPoint)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.mypage, action: \.mypage) {
      MyPageFeature()
    }
    Reduce { state, action in
      switch action {
      case let .requestLogin(isPresent, entryPoint):
        return .send(.delegate(.requestLogin(isPresent, entryPoint)))
        
      case let .mypage(.delegate(action)):
        switch action {
        case let .hiddenTabBar(isHidden):
          return .send(.delegate(.hiddenTabBar(isHidden)))
          
        case let .requestLogin(isPresent):
          return .send(.delegate(.requestLogin(isPresent, .mypage)))
        }
        
      default: return .none
      }
      
    }
    
  }
  
  
}
