//
//  AuthFlowReducer.swift
//  Sseudam
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import AuthFeature


extension SseudamFeature {
  struct AuthFlowReducer: Reducer {
    func reduce(
      into state: inout SseudamFeature.State,
      action: SseudamFeature.Action
    ) -> Effect<SseudamFeature.Action> {
      
      switch action {
        
        
      // Login 모달 delegate 처리
      case let .modal(.presented(.login(action))):
        switch action {
        case .delegate(.dismiss):
          return .send(.presentLogin(false))
          
        case let .delegate(.presentSignUp(email)):
          return .run { send in
            await send(.presentLogin(false))
            await send(.presentNickname(true, email))
          }

        default:
          return .none
        }
        
      // Nickname 입력 모달 delegate 처리
      case let .modal(.presented(.signUp(action))):
        switch action {
        case .delegate(.dismiss):
          return .run { send in
            await send(.presentNickname(false, nil))
          }
        case .delegate(.complete):
          return .run { send in
            await send(.presentNickname(false, nil))
            await send(.presentSignUpComplete(true))
          }
        default:
          return .none
        }
        
      case let .modal(.presented(.complete(action))):
        switch action {
        case .delegate(.dismiss):
          state.modal = nil
          return .none
        default: return .none
        }

      // 모달 상태 변경
      case let .presentLogin(isPresent):
        state.modal = isPresent ? .login(LoginFeature.State()) : nil
        return .none

      case let .presentNickname(isPresent, email):
        if isPresent, let email = email {
          state.modal = .signUp(NickNameInputFeature.State(email: email))
        } else {
          state.modal = nil
        }
        return .none

      case .presentSignUpComplete:
        state.modal = .complete(SignUpCompleteFeature.State())
        return .none

      default:
        return .none
      }
    }
  }
}
