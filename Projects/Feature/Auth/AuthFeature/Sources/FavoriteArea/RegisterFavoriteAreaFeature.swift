//
//  FavoriteAreaFeature.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import UserDomainInterface
import AuthDomainInterface
import KeyChain
import UserDefaults
import Utility

@Reducer
public struct RegisterFavoriteAreaFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var nickname: String
    var email: String
    var area: String = ""
    var focusKeyboard: Bool = false
    var searchItems: [String] = []
    var isSelectItem: Bool = false
    var errorToastMessage: String? = nil
    
    public init(email: String, nickname: String) {
      self.email = email
      self.nickname = nickname
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case showKeyboard(Bool)
    case dismiss
    case searchKeyword(String)
    case updateSearchAreaItems([String])
    case deleteAreaList
    case selectArea(String)
    case signUp
    case completeButtonTapped
    case successSignUp(nickname: String)
    case errorToastMessage(String)
    case signUpResult(Result<String, NetworkError>)
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case dismiss
  }
  
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.SearchAreaUseCase) var searchAreaUseCase
  @Dependency(\.SignUpUseCase) var signUpUseCase
  @Dependency(\.DeleteAreaListUseCase) var deleteAreaListUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce {
      state,
      action in
      switch action {
      case .onAppear:
        return .send(.showKeyboard(true))
        
      case let .showKeyboard(isShow):
        state.focusKeyboard = isShow
        return .none
        
      case .binding(\.area):
        state.isSelectItem = false
        return .send(.searchKeyword(state.area))
        
      case let .searchKeyword(keyword):
        return .run { send in
          let list = try await searchAreaUseCase.execute(keyword)
          await send(.updateSearchAreaItems(list))
        }
        
      case let .updateSearchAreaItems(items):
        state.searchItems = items
        return .none
        
      case .deleteAreaList:
        return .run { _ in
          try await deleteAreaListUseCase.execute()
        }
        
      case let .selectArea(area):
        state.area = area
        state.searchItems = []
        state.isSelectItem = true
        return .none
        
      case .dismiss:
        return .run { _ in
          await self.dismiss()
        }
        
      case .completeButtonTapped:
        return signUp(
          email: state.email,
          nickname: state.nickname,
          area: state.area
        )
        
      case let .signUpResult(result):
        switch result {
        case let .success(nickname):
          UserDefaultsKeys.isLoggedIn = true
          return .send(.successSignUp(nickname: nickname))
        case .failure:
          return .send(.errorToastMessage("회원가입에 실패했어요."))
        }
        
      case let .successSignUp(nickname):
        UserDefaultsKeys.username = nickname
        UserDefaultsKeys.isLoggedIn = true
        return .run { send in
          await send(.deleteAreaList)
          await send(.delegate(.dismiss))
        }

      case let .errorToastMessage(message):
        state.errorToastMessage = message
        return .none
        
      default: return .none
      }
    }
  }
  
  private func signUp(email: String, nickname: String, area: String) -> Effect<Action> {
    return .run { send in
      do {
        let input: SignUpInput = .init(
          email: email,
          nickname: nickname,
          address: area
        )
        try await signUpUseCase.execute(input)
        await send(.signUpResult(.success((nickname))))
      } catch let error as NetworkError {
        await send(.signUpResult(.failure(error)))
      }
    }
  }
}
