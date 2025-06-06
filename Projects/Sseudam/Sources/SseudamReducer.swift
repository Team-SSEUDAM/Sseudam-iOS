//
//  SseudamReducer.swift
//  Sseudam
//
//  Created by Jiyeon on 6/6/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SseudamReducer {
  
  @ObservableState
  struct State {
    var selectedTab: TabItem = .home
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case selectTab(TabItem)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    
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
