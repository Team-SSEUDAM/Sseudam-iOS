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
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case showKeyboard(Bool)
    case dismiss
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
        let keyword = state.area
        return .run { send in
          let result = try await searchAddressUseCase.execute(keyword)
          print("🔍 검색 결과:", result)
        }
        
      case .dismiss:
        return .run { _ in
          await self.dismiss()
        }
      default: return .none
      }
    }
  }
  
  
}
