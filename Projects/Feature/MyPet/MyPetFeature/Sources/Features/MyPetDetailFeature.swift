//
//  MyPetDetailFeature.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Utility
import DesignKit

import PetDomainInterface

@Reducer
public struct MyPetDetailFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    
    public var catHistoryCard: [CatHistoryCardRecord] = []
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case willFetchPetHistoryInfo
    case fetchPetHistoryInfo([CatHistoryCardRecord])
    case fetchPetHistoryInfoResult(Result<PetHistoryInfoEntity, NetworkError>)
    
    case backButtonTapped
    case pop
  }
  
  @Dependency(\.FetchPetHistoryInfoUseCase) var fetchPetHistoryInfoUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .willFetchPetHistoryInfo:
        return fetchPetHistoryInfo(fetchPetHistoryInfoUseCase)
        
      case let .fetchPetHistoryInfoResult(result):
        switch result {
        case let .success(records):
          return .send(fetchRealPetHistoryInfo(with: records))
        case let .failure(error):
          return .none
        }
        
      case let .fetchPetHistoryInfo(records):
        state.catHistoryCard = records
        return .none
        
      case .backButtonTapped:
        return .send(.pop)
      default: return .none
      }
    }
  }
}

extension MyPetDetailFeature {
  fileprivate func fetchPetHistoryInfo(
    _ useCase: FetchPetHistoryInfoUseCase
  ) -> Effect<Action> {
    .run { send in
      do {
        let entity = try await useCase.execute()
        await send(.fetchPetHistoryInfoResult(.success(entity)))
      } catch is CancellationError {
        await send(.fetchPetHistoryInfoResult(.failure(.taskCancelled)))
      } catch {
        await send(.fetchPetHistoryInfoResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
  
  fileprivate func fetchRealPetHistoryInfo(
    with historyInfo: PetHistoryInfoEntity
  ) -> Action {
    let records = historyInfo.petHistory.map { item -> CatHistoryCardRecord in
      let imageURL = CatImageSet.imageURL(
        level: item.levelType,
        type: item.season
      )
      return .init(nickname: item.nickname, imageURL: imageURL, levelType: item.levelType)
    }
    return .fetchPetHistoryInfo(records)
  }
}
