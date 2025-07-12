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
    var email: String? = nil
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case closeButtonTapped
    case appleLoginTapped
    case requestAppleLoginAuthroization
    case appleLoginServerRequest(token: String, email: String?)
    case presentSignUp
    case delegate(Delegate)
    case loginResult(Result<SocialLoginEntity, NetworkError>)
    case storeEmail(String?)
  }
  
  public enum Delegate: Equatable {
    case presentSignUp(email: String?)
    case dismiss
    case complete
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
        return .send(.requestAppleLoginAuthroization)
          .throttle(id: ID.throttle, for: 0.3, scheduler: mainQueue, latest: false)
        
      case .requestAppleLoginAuthroization:
        return requestAppleLoginAuthroization()
        
      case let .appleLoginServerRequest(token, email):
        return requestAppleLogin(token: token, email: email)
        
      case .presentSignUp:
        return .send(.delegate(.presentSignUp(email: state.email)))
        
      case let .loginResult(result):
        return handleLoginResult(result: result)
        
      case let .storeEmail(email):
        state.email = email
        return .none
        
      default: return .none
      }
    }
  }
  
  private func handleLoginResult(result: Result<SocialLoginEntity, NetworkError>) -> Effect<Action> {
    switch result {
    case let .success(data):
      return .run { send in
        await tokenSaveUseCase.execute(data)
        if data.isTempToken {
          return await send(.presentSignUp)
        } else {
          await send(.delegate(.complete))
        }
      }
    case .failure(_):
      return .send(.delegate(.dismiss))
    }
  }
  
  private func requestAppleLogin(token: String, email: String?) -> Effect<Action> {
    return .run { send in
      do {
        let data = try await appleLoginUseCase.execute(token)
        await send(.loginResult(.success(data)))
      } catch let error as NetworkError {
        await send(.loginResult(.failure(error)))
      } catch {
        await send(.loginResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
  
  private func requestAppleLoginAuthroization() -> Effect<Action> {
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
          await send(.storeEmail(email))
          await send(.appleLoginServerRequest(token: result.idToken, email: email))
        }
      } catch {
        print("[AppleLogin Failure] ", error.localizedDescription)
      }
    }
  }
}
