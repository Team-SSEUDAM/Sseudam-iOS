//
//  NickNameInputFeature.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct NickNameInputFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var nickname: String = ""
    var nicknameValid: NickNameInputValid = .none
    var focusKeyboard: Bool = false
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case showKeyboard(Bool)
    case checkValidNickName(String)
    case nicknameValidMessage(NickNameInputValid)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.nickname):
        return .send(.checkValidNickName(state.nickname))
      case .onAppear:
        return .send(.showKeyboard(true))
      case let .showKeyboard(isShow):
        state.focusKeyboard = isShow
        return .none
      case let .checkValidNickName(nickname):
        return .send(.nicknameValidMessage(checkNicknameValid(nickname)))
      case let .nicknameValidMessage(type):
        state.nicknameValid = type
        return .none
      default: return .none
      }
    }
  }
}

extension NickNameInputFeature {
  private func checkNicknameValid(_ nickname: String) -> NickNameInputValid {
    var inputValid: NickNameInputValid {
      if nickname.count < 2 {
        return .tooShort
      } else if nickname.count > 12 {
        return .tooLong
      } else if !nickname.isValidNicknameStrict {
        return .invalid
      } else {
        return .valid
      }
    }
    return inputValid
  }
}
