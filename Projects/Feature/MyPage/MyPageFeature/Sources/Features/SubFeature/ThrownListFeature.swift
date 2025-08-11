//
//  ThrownListFeature.swift
//  MyPageFeature
//
//  Created by 조용인 on 8/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Utility
import VisitedDomainInterface

@Reducer
public struct ThrownListFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    
    public var thrownList: [VisitedListEntity]? = nil
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case fetchThrownList
    case forceRefreshThrownList
    case thrownListResponse(Result<[VisitedListEntity], NetworkError>)
  }
  
  @Dependency(\.GetVisitedListUseCase) var getVisitedListUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .fetchThrownList:
        /// 이미 불러온 경우 중복 호출 방지 -> refresh 시도 할 때만 재 호출 하기 위함.
        return state.thrownList == nil ? fetchThrownLists() : .none
        
      case .forceRefreshThrownList:
        return fetchThrownLists()
        
      case let .thrownListResponse(result):
        switch result {
        case let .success(thrownList):
          print("Fetched Throwns: \(thrownList)")
          state.thrownList = thrownList
          return .none
          
        case let .failure(error):
          state.thrownList = nil
          print("Error fetching Throwns: \(error)")
          return .none
        }
        
      default:
        return .none
      }
    }
  }
}

extension ThrownListFeature {
  private func fetchThrownLists() -> Effect<Action> {
    return .run { send in
      do {
        let thrownList = try await getVisitedListUseCase.execute()
        await send(.thrownListResponse(.success(thrownList)))
      } catch let error as NetworkError {
        await send(.thrownListResponse(.failure(error)))
      } catch {
        await send(.thrownListResponse(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
}

