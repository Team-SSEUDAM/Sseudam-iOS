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
    case fetchGrowthList(PetInfoEntity)
    
    case fetchCatCards([CatCard])
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .fetchGrowthList(petInfo):
        /// TODO: - `CatType`도 외부에서 주입 가능하도록 변경해야함....!
        return fetchGrowthList(with: petInfo, season: .basic)
        
      case let .fetchCatCards(cards):
        state.catCards = cards
        return .none
        
      default: return .none
      }
    }
  }
}

extension MyPetGrowthListFeature {
  fileprivate func fetchGrowthList(
    with petInfo: PetInfoEntity,
    season: CatType
  ) -> Effect<Action> {
    let trasnformed = CatLevel.allCases.map { catLevel -> CatCard in
      let catImage = CatImageSet.imageURL(level: catLevel, type: season)
      return .init(
        isLocked: petInfo.levelType.rawInt < catLevel.rawInt,
        imageURL: catImage
      )
    }
    return .send(.fetchCatCards(trasnformed))
  }
}
  
