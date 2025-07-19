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
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case fetchPetSeasonInfo
    case fetchPetSeasonInfoResult(Result<PetSeasonInfoEntity, NetworkError>)
    
    case fetchCatCards([CatCard])
    case fetchGrowthRecords([GrowthRecord])
  }
  
  @Dependency(\.FetchPetSeasonInfoUseCase) var fetchPetSeasonInfoUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        
      case .fetchPetSeasonInfo:
        return fetchGrowthList()
        
      case let .fetchCatCards(catCards):
        state.catCards = catCards
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
  
  fileprivate func fetchCatCardsAction(with seasonData: PetSeasonInfoEntity) -> Action {
    let catCards = seasonData.seasonPetInfo.map { item -> CatCard in
      let imageURL = CatImageSet.imageURL(level: item.levelType, type: item.season)
      return .init(isLocked: item.isLocked, imageURL: imageURL)
    }
    return .fetchCatCards(catCards)
  }
  
  // 실제 구현 시 사용할 함수
  fileprivate func fetchGrowthRecordsAction(with seasonData: PetSeasonInfoEntity) -> Action {
    // 실제 구현 로직
    let growthRecords: [GrowthRecord] = [] // 실제 데이터 처리
    return .fetchGrowthRecords(growthRecords)
  }
}

