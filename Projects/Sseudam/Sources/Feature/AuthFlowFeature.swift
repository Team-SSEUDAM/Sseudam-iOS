//
//  AuthFlowReducer.swift
//  Sseudam
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import AuthFeature

@Reducer
struct AuthFlowFeature {
  @ObservableState
  struct State {
    var isLoginPresent: Bool = false
    @Presents var modal: ModalDestination.State?
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case presentLogin(Bool)
    case presentNickname(Bool, String?)
    case presentSignUpComplete(Bool)
    case changeLoginState(Bool)
    case modal(PresentationAction<ModalDestination.Action>)
    case delegate(Delegate)
  }
  
  enum Delegate: Equatable {
    case changeLoginState(Bool)
  }
  
  /// 모달로 띄우기 위한 뷰
  @Reducer(state: .equatable, action: .equatable)
  enum ModalDestination {
    case login(LoginFeature)
    case signUp(NickNameInputFeature)
    case complete(SignUpCompleteFeature)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
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
          
        case .delegate(.complete):
          return .run { send in
            await send(.changeLoginState(true))
            await send(.presentLogin(false))
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
          return .send(.presentSignUpComplete(true))
          
        default:
          return .none
        }
        
      // 회원가입 완료 delegate 처리
      case let .modal(.presented(.complete(action))):
        switch action {
        case .delegate(.dismiss):
          state.modal = nil
          return .send(.changeLoginState(true))
          
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

      // 로그인 상태 각 탭에 전달
      case let .changeLoginState(isLoggedIn):
        return .run { send in
          await send(.delegate(.changeLoginState(isLoggedIn)))
        }
        
      default:
        return .none
      }
      
    }
    .ifLet(\.$modal, action: \.modal)
  }
}
