//
//  HomeRootFeature.swift
//  Sseudam
//
//  Created by Jiyeon on 6/21/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import HomeFeature
import TrashDetailFeature

@Reducer
struct HomeRootFeature {
  
  @ObservableState
  struct State: Equatable {
    var home: HomeFeature.State = HomeFeature.State()
    var trashDetail: TrashDetailFeature.State? = nil
    var isPresentDetail: Bool = false
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case home(HomeFeature.Action)
    case trashDetail(TrashDetailFeature.Action)
    case delegate(Delegate)
  }
  
  enum Delegate: Equatable {
    case hiddenTabBar(Bool)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.home, action: \.home) {
      HomeFeature()
    }
    Reduce { state, action in
      switch action {
        
      case let .home(.delegate(.presentDetailView(isPresent))):
        state.trashDetail = isPresent ? .init() : nil
        state.isPresentDetail = isPresent
        return .none
      case let .home(.delegate(.needToHiddenTabBar(isHidden))):
        return .send(.delegate(.hiddenTabBar(isHidden)))
      default: return .none
      }
    }
    .ifLet(\.trashDetail, action: \.trashDetail) {
      TrashDetailFeature()
    }
  }
}
