//
//  NickNameInputFeature.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import UserDomainInterface

@Reducer
public struct NickNameInputFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var email: String
    var nickname: String = ""
    var nicknameValid: NickNameInputValid = .none
    var focusKeyboard: Bool = false
    var errorToastMessage: String? = nil
    var path = StackState<NavigationPath.State>()
    
    public init(email: String) {
      self.email = email
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case showKeyboard(Bool)
    case checkValidNickName(String)
    case nicknameValidMessage(NickNameInputValid)
    case completeButtonTapped
    case moveToRegisterArea
    case path(StackActionOf<NavigationPath>)
    case errorToastMessage(String)
    case loadAddress
    case delegate(Delegate)
  }
  
  @Reducer(state: .equatable, action: .equatable)
  public enum NavigationPath {
    case registerArea(RegisterFavoriteAreaFeature)
  }
  
  public enum Delegate {
    case dismiss
  }
  
  @Dependency(\.CheckNicknameValidateUseCase) var checkNicknameValidateUseCase
  @Dependency(\.LoadAddressListUseCase) var loadAddressListUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce {
      state,
      action in
      switch action {
      case .binding(\.nickname):
        return .send(.checkValidNickName(state.nickname))
        
      case .onAppear:
        
        return .run { send in
          await MainActor.run {
            send(.showKeyboard(true))
            send(.loadAddress)
          }
        }
        
      case .loadAddress:
        return .run { _ in
          try await loadAddressListUseCase.execute()
        }
      case let .showKeyboard(isShow):
        state.focusKeyboard = isShow
        return .none
        
      case let .checkValidNickName(nickname):
        return .send(.nicknameValidMessage(checkNicknameValid(nickname)))
        
      case let .nicknameValidMessage(type):
        state.nicknameValid = type
        return .none
        
      case .moveToRegisterArea:
        state.path.append(
          .registerArea(
            RegisterFavoriteAreaFeature.State(
              email: state.email,
              nickname: state.nickname
            )
          )
        )
        return .none
        
      case .completeButtonTapped:
        return checkDuplicatedNickname(state.nickname)
        
      case let .errorToastMessage(message):
        state.errorToastMessage = message
        return .none
        
      case .path(.element(id: let id, action: .registerArea(.delegate(.dismiss)))):

        return .send(.delegate(.dismiss))
        
      default: return .none
      }
    }
    .forEach(\.path, action: \.path)
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
  
  private func checkDuplicatedNickname(_ nickname: String) -> Effect<Action> {
    return .run { send in
      do {
        let result = try await checkNicknameValidateUseCase.execute(nickname)
        if result.isValid { // 닉네임 유효 -> 이동
          await(send(.moveToRegisterArea))
        } else {
          await send(.nicknameValidMessage(.duplicate))
        }
        
      } catch {
        await send(.errorToastMessage("회원가입에 실패했어요.."))
      }
    }
      
  }
}
