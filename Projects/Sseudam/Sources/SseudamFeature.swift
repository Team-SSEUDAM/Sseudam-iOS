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

@Reducer
struct SseudamFeature {
  
  @ObservableState
  struct State {
    var selectedTab: TabBarItem = .home
    var home: HomeFeature.State = HomeFeature.State()
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case selectTab(TabBarItem)
    case home(HomeFeature.Action)
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
        
      default: return .none
      }
    }
    
  }
  
}
