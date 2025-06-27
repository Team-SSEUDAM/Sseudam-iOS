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
    case presentSignUp(email: String?)
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case presentSignUp(email: String?)
    case dismiss
  }
  
  public enum ID: Hashable {
    case throttle
  }
  
  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.AppleLoginUseCase) var appleLoginUseCase
  @Dependency(\.TokenSaveUseCase) var tokenSaveUseCase
  
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
        
      case let .presentSignUp(email):
        return .send(.delegate(.presentSignUp(email: email)))
        
      default: return .none
      }
    }
  }
  
  private func requestAppleLogin() -> Effect<Action> {
    return .run { send in
      do {
        // 애플로그인 요청
        if let result = try await AppleLoginHelper.requestAuthorization() {
          var email: String? = result.email
          if let email = email {
            KeyChainService.save(email, forKey: .email)
          } else {
            email = KeyChainService.read(forKey: .email)
          }
          do {
            let data = try await appleLoginUseCase.execute(result.idToken)
            await tokenSaveUseCase.execute(data)
            if data.isTempToken {
              return await send(.presentSignUp(email: email))
            } else {
              await send(.delegate(.dismiss))
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
