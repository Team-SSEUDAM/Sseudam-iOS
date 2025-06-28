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
    @Presents var modal: ModalDestination.State?
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case selectTab(TabBarItem)
    
    case homeRoot(HomeRootFeature.Action)
    case mypageRoot(MyPageRootFeature.Action)
    
    case presentLogin(Bool)
    case presentNickname(Bool, String?)
    case presentSignUpComplete(Bool)
    case changeLoginState(Bool)
    case modal(PresentationAction<ModalDestination.Action>)
    
  }
  
  /// 모달로 띄우기 위한 뷰
  @Reducer(state: .equatable, action: .equatable)
  enum ModalDestination {
    case login(LoginFeature)
    case signUp(NickNameInputFeature)
    case complete(SignUpCompleteFeature)
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
        
      case let .mypageRoot(.delegate(.requestLogin(isPresent, _))):
        return .send(.presentLogin(isPresent))
        
        
      default: return .none
      }
    }
    .ifLet(\.$modal, action: \.modal)
    Reduce(AuthFlowReducer())
  }
  
}
