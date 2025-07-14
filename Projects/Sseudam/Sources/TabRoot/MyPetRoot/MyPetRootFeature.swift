//
//  MyPetRootFeature.swift
//  Sseudam
//
//  Created by 조용인 on 7/8/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import MyPetFeature
import AuthFeature

@Reducer
struct MyPetRootFeature {
  @ObservableState
  struct State {
    var myPet: MyPetFeature.State = MyPetFeature.State()
    init() {}
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case delegate(Delegate)
    
    case checkLoggedin
    case requestLogin(Bool, AuthEntryPoint)
    case myPet(MyPetFeature.Action)
  }
  
  enum Delegate: Equatable {
    case hiddenTabBar(Bool)
    case requestLogin(Bool, AuthEntryPoint)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.myPet, action: \.myPet) {
      MyPetFeature()
    }
    Reduce { state, action in
      switch action {
      case let .requestLogin(isPresent, entryPoint):
        return .send(.delegate(.requestLogin(isPresent, entryPoint)))
        
      case .checkLoggedin:
        return .send(.myPet(.checkLoggedIn))
        
      case let .myPet(.delegate(action)):
        switch action {
        case let .needToHiddenTabBar(isHidden):
          return .send(.delegate(.hiddenTabBar(isHidden)))
          
        case let .requestLogin(isPresent):
          return .send(.delegate(.requestLogin(isPresent, .mypet)))
        }
        
      default: return .none
      }
    }
  }
}
