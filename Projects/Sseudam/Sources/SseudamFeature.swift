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
    
    var homeRoot: HomeRootFeature.State = .init()
    var mypageRoot: MyPageRootFeature.State = .init()
    var authFlow: AuthFlowFeature.State? = nil
    var presentAlert: AlertType? = nil
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case selectTab(TabBarItem)
    
    case homeRoot(HomeRootFeature.Action)
    case mypageRoot(MyPageRootFeature.Action)
    case authFlow(AuthFlowFeature.Action)
    
    case closeAlertAction
    case acceptAlertAction
    case dismissAlert(Bool)
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
        
      case let .homeRoot(.delegate(.presentAlert(type))):
        state.presentAlert = type
        return .none
        
      case let .homeRoot(.delegate(.hiddenTabBar(isHidden))):
        state.isTabbarHidden = (isHidden)
        return .none
        
      case let .mypageRoot(.delegate(.requestLogin(isPresent, _))):
        state.authFlow = isPresent ? .init() : nil
        return .send(.authFlow(.presentLogin(isPresent)))
        
      case let .authFlow(.delegate(.changeLoginState(isLoggedIn))):
        return .run { send in
          await send(.mypageRoot(.loginState(isLoggedIn)))
        }
        
        // MARK: - Alert
        
      case .closeAlertAction:
        guard let type = state.presentAlert else { return .none }
        return alertEffect(for: type, result: .close)

      case .acceptAlertAction:
        guard let type = state.presentAlert else { return .none }
        return alertEffect(for: type, result: .accept)
        
      case .dismissAlert:
        state.presentAlert = nil
        return .none
        
      default: return .none
      }
    }
    .ifLet(\.authFlow, action: \.authFlow) {
      AuthFlowFeature()
    }
  }
  
}

extension SseudamFeature {

  private func alertEffect(
    for type: AlertType,
    result: AlertResult
  ) -> Effect<Action> {
    .run { send in
      switch (type, result) {
      case (.locationPermission, .close):
        await send(.homeRoot(.closeAlertAction(type)))
      case (.locationPermission, .accept):
        await send(.homeRoot(.acceptAlertAction(type)))

      default: return
      }

      // 공통적으로 알림 닫기
      await send(.dismissAlert(true))
    }
  }
}
