//
//  SuggestionListFeature.swift
//  MyPageFeature
//
//  Created by 조용인 on 8/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Utility
import ComposableArchitecture
import SuggestionDomainInterface


@Reducer
public struct SuggestionListFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    
    public var suggestions: [SuggestionListEntity]? = nil
    
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case fetchSuggestions
    case suggestionsResponse(Result<[SuggestionListEntity], NetworkError>)
  }
  
  @Dependency(\.GetSuggestionListUseCase) var getSuggestionListUseCase

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .fetchSuggestions:
        /// 이미 불러온 경우 중복 호출 방지 -> refresh 시도 할 때만 재 호출 하기 위함.
        return state.suggestions == nil ? fetchSuggestions() : .none
        
      case let .suggestionsResponse(result):
        switch result {
        case let .success(suggestions):
          print("Fetched suggestions: \(suggestions)")
          state.suggestions = suggestions
          return .none
          
        case let .failure(error):
          state.suggestions = nil
          print("Error fetching suggestions: \(error)")
          return .none
        }
      default:
        return .none
      }
    }
  }
}

extension SuggestionListFeature {
  private func fetchSuggestions() -> Effect<Action> {
    return .run { send in
      do {
        let suggestions = try await getSuggestionListUseCase.execute()
        await send(.suggestionsResponse(.success(suggestions)))
      } catch let error as NetworkError {
        await send(.suggestionsResponse(.failure(error)))
      } catch {
        await send(.suggestionsResponse(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
}
