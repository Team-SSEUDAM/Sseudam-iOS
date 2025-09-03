//
//  SseudamFeature.swift
//  Sseudam
//
//  Created by Jiyeon on 6/6/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Utility
import DesignKit
import ComposableArchitecture
import UserDefaults

import HomeFeature
import MyPetFeature
import TrashDetailFeature
import AuthFeature
import AttendanceFeature

@Reducer
struct SseudamFeature {
  
  @ObservableState
  struct State {
    var selectedTab: TabBarItem = .home
    var isTabbarHidden: Bool = false
    var isFirstEntry: Bool = true
    
    var homeRoot: HomeRootFeature.State = .init()
    var myPetRoot: MyPetRootFeature.State = .init()
    var mypageRoot: MyPageRootFeature.State = .init()
    
    var forceUpdateCheck: ForceUpdateFeature.State = .init()
    var mixpanel: MixPanelFeature.State = .init()
    var authFlow: AuthFlowFeature.State? = nil
    var userEntry: UserEntryFeature.State? = nil
    
    var presentAlert: AlertType? = nil
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case selectTab(TabBarItem)
    case onAppear
    case checkUserEntryState(userId: Int)
    
    case homeRoot(HomeRootFeature.Action)
    case myPetRoot(MyPetRootFeature.Action)
    case mypageRoot(MyPageRootFeature.Action)
    case authFlow(AuthFlowFeature.Action)
    case userEntry(UserEntryFeature.Action)
    case forceUpdateCheck(ForceUpdateFeature.Action)
    case mixpanel(MixPanelFeature.Action)
    
    case requestLogin(isPresent: Bool)
    case open(URL)
    
    case closeAlertAction
    case acceptAlertAction
    case dismissAlert(Bool)
    
  }
  
  @Dependency(\.openURL) var openURL
  @Dependency(\.date.now) var now
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.homeRoot, action: \.homeRoot) {
      HomeRootFeature()
    }
    Scope(state: \.myPetRoot, action: \.myPetRoot) {
      MyPetRootFeature()
    }
    Scope(state: \.mypageRoot, action: \.mypageRoot) {
      MyPageRootFeature()
    }
    Scope(state: \.forceUpdateCheck, action: \.forceUpdateCheck) {
      ForceUpdateFeature()
    }
    Scope(state: \.mixpanel, action: \.mixpanel) {
      MixPanelFeature()
    }

    Reduce { state, action in
      switch action {
      case let .selectTab(tab):
        state.selectedTab = tab
        return .none
        
      case .onAppear:
        state.isFirstEntry = false
        let sessionId = UUID().uuidString
        let ctx = currentUserCtx()
        return .merge(
          .send(.forceUpdateCheck(.onAppear)),
          checkIsLoggedIn(),
          .send(.mixpanel(.track(.appViewedSplash(
            session_id: sessionId,
            timestamp: now,
            ctx: ctx
          )))),
          .send(.mixpanel(.track(.sessionStarted(
            session_duration: nil,           // TODO: scenePhase로 계산해 채우기
            previous_session_gap: nil,       // TODO: 이전 종료시각 기반
            ctx: ctx
          ))))
        )
        
      case let .open(url):
        return .run { send in
          await openURL(url)
        }
        
      case let .checkUserEntryState(userId):
        state.userEntry = .init(userId: userId)
        return .send(.userEntry(.checkAttendance))
        
      case let .homeRoot(.delegate(.presentAlert(type))):
        state.presentAlert = type
        return .none
        
      case let .homeRoot(.delegate(.hiddenTabBar(isHidden))):
        state.isTabbarHidden = (isHidden)
        return .none
        
      case let .mypageRoot(.delegate(.requestLogin(isPresent, _))):
        state.authFlow = isPresent ? .init() : nil
        return .send(.authFlow(.presentLogin(isPresent)))
        
      case let .mypageRoot(.delegate(.hiddenTabBar(isHidden))):
        state.isTabbarHidden = (isHidden)
        return .none
        
      case let .myPetRoot(.delegate(.requestLogin(isPresent, _))):
        state.authFlow = isPresent ? .init() : nil
        return .send(.authFlow(.presentLogin(isPresent)))
        
      case let .myPetRoot(.delegate(.hiddenTabBar(isHidden))):
        state.isTabbarHidden = (isHidden)
        return .none
        
      case let .forceUpdateCheck(.delegate(.presentAlert(type))):
        state.presentAlert = type
        return .none
        
      case .authFlow(.delegate(.changeLoginState)):
        return .merge(
          checkIsLoggedIn(),
          .send(.mypageRoot(.checkLoggedin)),
          .send(.myPetRoot(.checkLoggedin)),
          .send(.homeRoot(.checkLoggedin))
        )
        
      case let .requestLogin(isPresent):
        state.authFlow = isPresent ? .init() : nil
        return .send(.authFlow(.presentLogin(isPresent)))
        
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
        
        // MARK: - UserEntry
      case let .userEntry(.delegate(action)):
        switch action {
        case .checkComplete:
          state.userEntry = nil
          return .none
        }
        
      default: return .none
      }
    }
    .ifLet(\.authFlow, action: \.authFlow) {
      AuthFlowFeature()
    }
    .ifLet(\.userEntry, action: \.userEntry) {
      UserEntryFeature()
    }
  }
  
}

extension SseudamFeature {
  
  private func checkIsLoggedIn() -> Effect<Action> {
    if UserDefaultsKeys.isLoggedIn ?? false ,
       let userId = UserDefaultsKeys.userId {
      return .send(.checkUserEntryState(userId: userId))
    }
    return .none
  }

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
        
      case (.login, .close):
        await send(.homeRoot(.closeAlertAction(type)))
      case (.login, .accept):
        await send(.requestLogin(isPresent: true))
        
      case (.forceAppUpdate(let url), .accept):
        await send(.open(url))

      case (.optionalAppUpdate(let url), .accept):
        await send(.open(url))
      case (.optionalAppUpdate, .close):
        await send(.homeRoot(.closeAlertAction(type)))
        
      default: return
      }

      // 공통적으로 알림 닫기
      await send(.dismissAlert(true))
    }
  }
  
  fileprivate func currentUserCtx() -> UserCtx {
    let isLoggedIn = UserDefaultsKeys.isLoggedIn ?? false
    let uid: String? = {
      guard isLoggedIn, let id = UserDefaultsKeys.userId else { return nil }
      return String(id)
    }()
    
    // TODO: 실제 값 연결 (지역/레벨)
    let userLocation: String? = nil
    let userLevel: Int? = nil
    
    return UserCtx(
      user_id: uid,
      user_location: userLocation,
      user_level: userLevel,
      user_login: isLoggedIn
    )
  }
}
