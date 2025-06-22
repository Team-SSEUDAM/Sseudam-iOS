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
    var isTabbarHidden: Bool = false
    var isLoginPresent: Bool = false
    
    var homeRoot: HomeRootFeature.State = .init()
    var mypageRoot: MyPageRootFeature.State = .init()
    var login: LoginFeature.State? = nil
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case selectTab(TabBarItem)
    
    case homeRoot(HomeRootFeature.Action)
    case mypageRoot(MyPageRootFeature.Action)
    
    case presentLogin(Bool)
    case login(LoginFeature.Action)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.homeRoot, action: \.homeRoot) {
      HomeRootFeature()
    }
    Scope(state: \.mypageRoot, action: \.mypageRoot) {
      MyPageRootFeature()
    }
    Reduce { state, action in
      switch action {
      case let .selectTab(tab):
        state.selectedTab = tab
        return .none
      case let .homeRoot(.delegate(.hiddenTabBar(isHidden))):
        state.isTabbarHidden = (isHidden)
        return .none
        
        // MARK: - Login
        
      case let .mypageRoot(.delegate(.requestLogin(isPresent, _))):
        return .send(.presentLogin(isPresent))
        
      case let .presentLogin(isPresent):
        state.isLoginPresent = isPresent
        state.login = isPresent ? .init() : nil
        return .none
        
      case .login(.delegate(.dismiss)):
        return .send(.presentLogin(false))
        
      default: return .none
      }
    }
    .ifLet(\.login, action: \.login) {
      LoginFeature()
    }
    
  }
  
}
