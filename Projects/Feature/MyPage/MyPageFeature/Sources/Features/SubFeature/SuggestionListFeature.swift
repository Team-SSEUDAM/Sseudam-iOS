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
        return fetchSuggestions()
        
      case let .suggestionsResponse(result):
        switch result {
        case let .success(suggestions):
          print("Fetched suggestions: \(suggestions)")
          return .none
          
        case let .failure(error):
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
