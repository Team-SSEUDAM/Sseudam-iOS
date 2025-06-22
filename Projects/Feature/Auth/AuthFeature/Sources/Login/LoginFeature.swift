//
//  LoginFeature.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import Utility

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
    case appleLoginTapped
    case appleLoginRequest
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case dismiss
  }
  
  public enum ID: Hashable {
    case throttle
  }
  
  @Dependency(\.mainQueue) var mainQueue
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .closeButtonTapped:
        return .send(.delegate(.dismiss))
        
      case .appleLoginTapped:
        return .send(.appleLoginRequest)
          .throttle(id: ID.throttle, for: 0.3, scheduler: mainQueue, latest: false)
      case .appleLoginRequest:
        return .run { send in
          do {
            // 애플로그인 요청
            if let result = try await AppleLoginHelper.requestAuthorization() {
              print(result)
            }
          } catch {
            print("[AppleLogin Failure] ", error.localizedDescription)
          }
        }
        
      default: return .none
      }
    }
  }
}
