//
//  LoginFeature.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import Utility
import KeyChain
import AuthDomainInterface

@Reducer
public struct LoginFeature {
  public init() { }
  
  @ObservableState
  public struct State: Equatable {
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case closeButtonTapped
    case appleLoginTapped
    case appleLoginRequest
    case requestLogin
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case presentSignUp
    case dismiss
  }
  
  public enum ID: Hashable {
    case throttle
  }
  
  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.AppleLoginUseCase) var appleLoginUseCase
  
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
        return requestAppleLogin()
      case .requestLogin:
        // TODO: - 로그인 api 연결
        return .send(.delegate(.presentSignUp))
        
      default: return .none
      }
    }
  }
  
  
  private func requestAppleLogin() -> Effect<Action> {
    return .run { send in
      do {
        // 애플로그인 요청
        if let result = try await AppleLoginHelper.requestAuthorization() {
          if let email = result.email {
            KeyChainService.save(email, forKey: .email)
          }
          print(result)
          do {
            let data = try await appleLoginUseCase.execute(result.idToken)
            if data.isTempToken {
              return await send(.requestLogin)
            }
          } catch {
            return await send(.delegate(.dismiss))
          }
          
        }
      } catch {
        print("[AppleLogin Failure] ", error.localizedDescription)
      }
    }
  }
}
