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
import AuthFeature

@Reducer
public struct MyPetDetailFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    
    public var catHistoryCard: [CatHistoryCardRecord] = [
      CatHistoryCardRecord(
        nickname: "너무 너무 너무나 고양이",
        imageURL: "type:basic_3, interaction:true",
        levelType: .level3
      ),
      CatHistoryCardRecord(
        nickname: "응애 고양이",
        imageURL: "type:basic_1, interaction:true",
        levelType: .level1
      ),
      CatHistoryCardRecord(
        nickname: "응애 응우앤 고양이",
        imageURL: "type:basic_5, interaction:false",
        levelType: .level5
      ),
      CatHistoryCardRecord(
        nickname: "응애 응우앤 고양이",
        imageURL: "type:basic_5, interaction:false",
        levelType: .level5
      ),
      CatHistoryCardRecord(
        nickname: "응애 응우앤 고양이",
        imageURL: "type:basic_5, interaction:false",
        levelType: .level5
      ),
      CatHistoryCardRecord(
        nickname: "응애 응우앤 고양이",
        imageURL: "type:basic_5, interaction:false",
        levelType: .level5
      )
    ]
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case willFetchPetHistoryInfo
    case fetchPetHistoryInfo([CatHistoryCardRecord])
    case fetchPetHistoryInfoResult(Result<[CatHistoryCardRecord], NetworkError>)
    
    case backButtonTapped
    case pop
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .willFetchPetHistoryInfo:
        return fetchPetHistoryInfo()
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
  fileprivate func fetchPetHistoryInfo() -> Effect<Action> {
    return .none
  }
}
