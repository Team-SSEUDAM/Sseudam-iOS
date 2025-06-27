//
//  FavoriteAreaFeature.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import UserDomainInterface

@Reducer
public struct RegisterFavoriteAreaFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var area: String = ""
    var focusKeyboard: Bool = false
    var searchItems: [String] = []
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case showKeyboard(Bool)
    case dismiss
    case searchKeyword(String)
    case updateSearchAreaItems([String])
    case selectArea(String)
  }
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.SearchAddressUseCase) var searchAddressUseCase
  
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
        return .send(.searchKeyword(state.area))
        
      case let .searchKeyword(keyword):
        return .run { send in
          let list = try await searchAddressUseCase.execute(keyword)
          await send(.updateSearchAreaItems(list))
        }
        
      case let .updateSearchAreaItems(items):
        state.searchItems = items
        return .none
        
      case let .selectArea(area):
        state.area = area
        state.searchItems = []
        return .none
        
      case .dismiss:
        return .run { _ in
          await self.dismiss()
        }
      default: return .none
      }
    }
  }
  
  
}
