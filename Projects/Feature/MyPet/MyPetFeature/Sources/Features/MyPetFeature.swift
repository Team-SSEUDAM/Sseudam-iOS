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
    public var isLoggedIn: Bool = false
    public var isPresentMyPetSheet: Bool = false
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case checkLoggedIn
    
    case hideMyPetBottomSheet(Bool)
    
    
    case loginState(Bool)
    case delegate(Delegate)
    
    case requestLogin(Bool, AuthEntryPoint)
    
  }
  
  public enum Delegate: Equatable {
    case requestLogin(Bool, AuthEntryPoint)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .hideMyPetBottomSheet(isHide):
        state.isPresentMyPetSheet = isHide == false
        return .none
        
      case .onAppear:
        return .send(.checkLoggedIn)
        
      case .checkLoggedIn:
        state.isLoggedIn = UserDefaultsKeys.isLoggedIn ?? false
        return .none
        
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
