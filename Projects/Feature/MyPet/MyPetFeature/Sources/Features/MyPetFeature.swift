//
//  MyPetFeature.swift
//
//  MyPet
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture
import UserDefaults
import AuthFeature

@Reducer
public struct MyPetFeature {
  
  public init() {}
  
  @ObservableState
  public struct State {
    public var isLoggedIn: Bool
    
    public init() {
      self.isLoggedIn = UserDefaultsKeys.isLoggedIn ?? false
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case loginState(Bool)
    case delegate(Delegate)
    
    case requestLogin(Bool, AuthEntryPoint)
    
  }
  
  public enum Delegate: Equatable {
    case hiddenTabBar(Bool)
    case requestLogin(Bool, AuthEntryPoint)
  }
  
  public var body: some ReducerOf<Self> {
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
