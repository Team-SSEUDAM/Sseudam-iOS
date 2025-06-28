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
    case errorToastMessage(String)
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case dismiss
  }
  
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.SearchAddressUseCase) var searchAddressUseCase
  @Dependency(\.SignUpUseCase) var signUpUseCase
  @Dependency(\.DeleteAddressListUseCase) var deleteAddressListUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
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
          let list = try await searchAddressUseCase.execute(keyword)
          await send(.updateSearchAreaItems(list))
        }
        
      case let .updateSearchAreaItems(items):
        state.searchItems = items
        return .none
        
      case .deleteAreaList:
        return .run { _ in
          try await deleteAddressListUseCase.execute()
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
        let email = state.email
        let nickname = state.nickname
        let area = state.area
        return .run { send in
          do {
            try await signUpUseCase.execute(email, nickname, area)
            UserDefaultsKeys.username = nickname
            UserDefaultsKeys.isLoggedIn = true
            await send(.deleteAreaList)
            await send(.delegate(.dismiss))
          } catch {
            await send(.errorToastMessage("회원가입에 실패했어요"))
          }
        }
      
      case let .errorToastMessage(message):
        state.errorToastMessage = message
        return .none
        
      default: return .none
      }
    }
  }
  
  
}
