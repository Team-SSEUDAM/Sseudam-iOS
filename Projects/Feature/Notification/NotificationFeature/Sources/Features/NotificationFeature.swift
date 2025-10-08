//
//  NotificationFeature.swift
//
//  Notification
//
//  Created by Jiyeon
//

import ComposableArchitecture
import UserDefaults

@Reducer
public struct NotificationFeature {
  
  public init() { }
  
  @ObservableState
  public struct State: Equatable {
    public var isLoggedIn: Bool = false
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case checkLoggedIn
    case requestLogin
    
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case requestLogin(Bool)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.checkLoggedIn)
        
      case .checkLoggedIn:
        state.isLoggedIn = UserDefaultsKeys.isLoggedIn ?? false
        return .none
        
      case .requestLogin:
        return .send(.delegate(.requestLogin(true)))
        
        default: return .none
      }
    }
  }
}
