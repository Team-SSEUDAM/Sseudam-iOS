//
//  MyPetGrowthListFeature.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import Utility

import PetDomainInterface

@Reducer
public struct MyPetGrowthListFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var catCards: [CatCard] = []
    public var growthRecords: [GrowthRecord] = []
    public var historyCards: [CatCard] = [] // 실제 history 데이터를 위한 필드 추가
    public var season: CatType = ._2025_07
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case delegate(Delegate)
    case fetchPetSeasonInfo
    case fetchPetSeasonInfoResult(Result<PetSeasonInfoEntity, NetworkError>)
    case fetchPetHistoryInfo
    case fetchPetHistoryInfoResult(Result<PetHistoryInfoEntity, NetworkError>)
    
    case fetchCatCards([CatCard], CatType)
    case fetchGrowthRecords([GrowthRecord])
    case fetchHistoryCards([CatCard])
    
    public enum Delegate: Equatable {
      case petDetailButtonTapped
    }
  }
  
  @Dependency(\.FetchPetSeasonInfoUseCase) var fetchPetSeasonInfoUseCase
  @Dependency(\.FetchPetHistoryInfoUseCase) var fetchPetHistoryInfoUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        
      case .fetchPetSeasonInfo:
        return .merge(
          fetchGrowthList(),
          fetchPetHistory() // 동시에 history 데이터도 가져옴
        )
        
      case .fetchPetHistoryInfo:
        return fetchPetHistory()
        
      case let .fetchPetHistoryInfoResult(result):
        switch result {
        case let .success(entity):
          return .send(fetchHistoryCardsAction(with: entity))
        case .failure:
          return .none
        }
        
      case let .fetchHistoryCards(cards):
        state.historyCards = cards
        return .none
        
      case let .fetchCatCards(catCards, catType):
        state.catCards = catCards
        state.season = catType
        return .none
        
      case let .fetchGrowthRecords(growthRecords):
        state.growthRecords = growthRecords
        return .none
        
      default: return .none
      }
    }
  }
}

extension MyPetGrowthListFeature {
  fileprivate func fetchGrowthList() -> Effect<Action> {
    return .run { send in
      do {
        let entity = try await fetchPetSeasonInfoUseCase.execute()
        
        // MARK: - 여기 병합 시켜야함....
        await send(fetchCatCardsAction(with: entity))
        await send(fetchGrowthRecordsAction(with: entity))
      } catch is CancellationError {
        await send(.fetchPetSeasonInfoResult(.failure(.taskCancelled)))
      } catch {
        await send(.fetchPetSeasonInfoResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }

  fileprivate func fetchPetHistory() -> Effect<Action> {
    return .run { send in
      do {
        let entity = try await fetchPetHistoryInfoUseCase.execute()
        await send(.fetchPetHistoryInfoResult(.success(entity)))
      } catch is CancellationError {
        await send(.fetchPetHistoryInfoResult(.failure(.taskCancelled)))
      } catch {
        await send(.fetchPetHistoryInfoResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
  
  fileprivate func fetchCatCardsAction(with seasonData: PetSeasonInfoEntity) -> Action {
    let catCards = Dictionary(grouping: seasonData.seasonPetInfo) { $0.season }
      .compactMap { _, pets in
        pets.max { $0.createdAt < $1.createdAt }
      }
      .map { pet in
        let imageURL = CatImageSet.imageURL(level: pet.levelType, type: pet.season)
        return CatCard(isLocked: pet.isLocked, imageURL: imageURL)
      }
    let catType = seasonData.seasonPetInfo.first?.season ?? ._2025_07
    return .fetchCatCards(catCards, catType)
  }
  
  fileprivate func fetchGrowthRecordsAction(with seasonData: PetSeasonInfoEntity) -> Action {
    let catCards = seasonData.seasonPetInfo.map { item -> CatCard in
      let imageURL = CatImageSet.imageURL(level: item.levelType, type: item.season)
      return .init(isLocked: item.isLocked, imageURL: imageURL)
    }
    
    let growthRecords = seasonData.seasonPetInfo.enumerated().map { index, item -> GrowthRecord in
      return .init(
        catCard: catCards[index],
        levelType: item.levelType,
        goalStamp: item.needPoint,
        nickname: item.nickname,
        createdAt: item.createdAt
      )
    }
    return .fetchGrowthRecords(growthRecords)
  }

  fileprivate func fetchHistoryCardsAction(with historyInfo: PetHistoryInfoEntity) -> Action {
    let historyCards = historyInfo.petHistory.map { item -> CatCard in
      let imageURL = CatImageSet.imageURL(
        level: item.levelType,
        type: item.season
      )
      return CatCard(isLocked: false, imageURL: imageURL)
    }
    return .fetchHistoryCards(historyCards)
  }
}
