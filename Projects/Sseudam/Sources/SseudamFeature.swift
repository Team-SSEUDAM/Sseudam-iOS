//
//  SseudamFeature.swift
//  Sseudam
//
//  Created by Jiyeon on 6/6/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture

import HomeFeature
import TrashDetailFeature

@Reducer
struct SseudamFeature {
  
  @ObservableState
  struct State {
    var selectedTab: TabBarItem = .home
    var home: HomeFeature.State = HomeFeature.State()
    var trashDetail: TrashDetailFeature.State? = nil
    var isPresentDetail: Bool = false
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case selectTab(TabBarItem)
    case home(HomeFeature.Action)
    case trashDetail(TrashDetailFeature.Action)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.home, action: \.home) {
      HomeFeature()
    }
    Reduce { state, action in
      switch action {
      case let .selectTab(tab):
        state.selectedTab = tab
        return .none
      case let .home(.delegate(.presentDetailView(isPresent))):
        state.trashDetail = isPresent ? .init() : nil
        state.isPresentDetail = isPresent
        return .none
      default: return .none
      }
    }
    .ifLet(\.trashDetail, action: \.trashDetail) {
      TrashDetailFeature()
    }
    
  }
  
}
