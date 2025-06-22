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
import AuthFeature

@Reducer
struct SseudamFeature {
  
  @ObservableState
  struct State {
    var selectedTab: TabBarItem = .home
    var homeRoot: HomeRootFeature.State = .init()
    var isTabbarHidden: Bool = false
    var auth: AuthFeature.State = AuthFeature.State()
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case selectTab(TabBarItem)
    case homeRoot(HomeRootFeature.Action)
    case auth(AuthFeature.Action)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.homeRoot, action: \.homeRoot) {
      HomeRootFeature()
    }
    Scope(state: \.auth, action: \.auth) {
      AuthFeature()
    }
    Reduce { state, action in
      switch action {
      case let .selectTab(tab):
        state.selectedTab = tab
        return .none
      case let .homeRoot(.delegate(.hiddenTabBar(isHidden))):
        state.isTabbarHidden = (isHidden)
        return .none
      default: return .none
      }
    }
    
  }
  
}
