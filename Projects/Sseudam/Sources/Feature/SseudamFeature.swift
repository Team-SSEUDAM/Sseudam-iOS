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
import AnalyticsKit

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
    case scenePhaseChanged(ScenePhase)
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
    
    case userLocationChanged(String)
  }
  
  @Dependency(\.openURL) var openURL
  @Dependency(\.sessionTracker) var sessionTracker
  
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

    Reduce {
      state,
      action in
      switch action {
      case let .selectTab(tab):
        state.selectedTab = tab
        return .none
        
      case .onAppear:
        return .none
        
      case .scenePhaseChanged(.active):
        return .merge(
          .send(.forceUpdateCheck(.onAppear)),
          checkIsLoggedIn(),
          .run { send in
            let ctx = currentUserCtx()
            let info = await sessionTracker.start(Date())
            await send(
              .mixpanel(
                .track(
                  .sessionStarted(
                    session_duration: info.previous_session_duration,
                    previous_session_gap: info.previous_session_gap,
                    ctx: ctx
                  )
                )
              )
            )
          }
        )
        
      case .scenePhaseChanged(.background):
        return .run { _ in
          await sessionTracker.end(Date())
        }
        
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
        
      case let .homeRoot(.mixPanel(action)):
        switch action {
        case .suggestionStart:
          return .run { send in
            await send(
              .mixpanel(
                .track(
                  .suggestionStartNew(
                    ctx: currentUserCtx()
                  )
                )
              )
            )
          }
          
        case .suggestionClickLocation:
          return .run { send in
            await send(
              .mixpanel(
                .track(
                  .suggestionClickLocation(
                    ctx: currentUserCtx()
                  )
                )
              )
            )
          }
          
        case .suggestionSetLocation:
          return .run { send in
            await send(
              .mixpanel(
                .track(
                  .suggestionSetLocation(
                    ctx: currentUserCtx()
                  )
                )
              )
            )
          }
          
        case let .suggestionInputName(length):
          return .run { send in
            await send(
              .mixpanel(
                .track(
                  .suggestionInputName(
                    description_length: length,
                    ctx: currentUserCtx()
                  )
                )
              )
            )
          }
          
        case let .suggestionSelectCategory(type):
          return .run { send in
            await send(
              .mixpanel(
                .track(
                  .suggestionSelectCategory(
                    trash_type: type,
                    ctx: currentUserCtx()
                  )
                )
              )
            )
          }
          
        case let .suggestionUploadPhoto(file_size, photo_type):
          return .run { send in
            await send(
              .mixpanel(
                .track(
                  .suggestionUploadPhoto(
                    file_size: file_size,
                    photo_type: photo_type,
                    ctx: currentUserCtx()
                  )
                )
              )
            )
          }
          
        case let .suggestionCompleteSubmission(submission_id):
          return .run { send in
            await send(
              .mixpanel(
                .track(
                  .suggestionCompleteSubmission(
                    submission_id: submission_id,
                    ctx: currentUserCtx()
                  )
                )
              )
            )
          }
          
        case .reportStart:
          return .run { send in
            await send(
              .mixpanel(
                .track(
                  .reportStartNew(
                    ctx: currentUserCtx()
                  )
                )
              )
            )
          }
          
        case let .reportSelectCategory(repoty_type):
          return .run { send in
            await send(
              .mixpanel(
                .track(
                  .reportSelectCategory(
                    selected_info_types: repoty_type,
                    ctx: currentUserCtx()
                  )
                )
              )
            )
          }
          
        case .reportCompleteSubmission:
          return .run { send in
            await send(
              .mixpanel(
                .track(
                  .reportCompleteSubmission(
                    ctx: currentUserCtx()
                  )
                )
              )
            )
          }
          
        case let .category(categoryType, userLogin):
          return .run { send in
            await send(.mixpanel(.track(
              .mapCategoryTapped(
                category_type: categoryType,
                user_login: userLogin,
                ctx: currentUserCtx()
              )
            )))
          }
        }
        
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
        
      case let .userEntry(.mixPanel(action)):
        switch action {
        case let .attendanceComplete(count):
          return .run { send in
            await send(
              .mixpanel(
                .track(
                  .attendanceCompletedNth(
                    streak_count: count,
                    ctx: currentUserCtx()
                  )
                )
              )
            )
          }
        }
        
        
        // MARK: - User Location
      case let .userLocationChanged(location):
        UserDefaultsKeys.userLocation = location
        return .none
        
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
  
  fileprivate func currentUserCtx() -> UserCtx? {
    guard let isLoggedIn = UserDefaultsKeys.isLoggedIn, isLoggedIn else { return nil} /// 로그인 상태 모름 -> nil
    let userId = UserDefaultsKeys.userId
    let userLevel = UserDefaultsKeys.current_catlevel
    let userLocation = UserDefaultsKeys.userLocation
    
    return UserCtx(
      user_id: userId,
      user_location: userLocation,
      user_level: userLevel
    )
  }
}
