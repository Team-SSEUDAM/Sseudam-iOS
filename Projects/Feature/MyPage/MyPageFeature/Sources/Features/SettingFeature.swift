//
//  SettingFeature.swift
//  MyPageFeature
//
//  Created by Jiyeon on 7/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import Utility
import UserDefaults

@Reducer
public struct SettingFeature {
  
  public init() { }
  
  @ObservableState
  public struct State: Equatable {
    var isLoggedIn: Bool = true
    var isNotiOn: Bool = true
    public var version: String = ""
    public var isNeedUpdate: Bool = false
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case checkAppVersion
    case configVersionInfo(String, Bool)
    case checkLoggedIn
    case notiAllow
    case logout
    case withdrwal
    
    case pop
    case delegate(Delegate)
  }
  
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    
  }
  
  public enum Delegate: Equatable {
    case pop
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .merge([
          .send(.checkLoggedIn),
          .send(.checkAppVersion)
        ])
        
      case .checkAppVersion:
        return checkAppVersion()
        
      case let .configVersionInfo(version, isNeedUpdate):
        state.version = version
        state.isNeedUpdate = isNeedUpdate
        return .none
        
      case .checkLoggedIn:
        state.isLoggedIn = UserDefaultsKeys.isLoggedIn ?? false
        return .none
        
      case .notiAllow:
        return .none
        
      case .pop:
        return .send(.delegate(.pop))
        
      default: return .none
      }
    }
  }
  
  private func checkAppVersion() -> Effect<Action> {
    return .run { send in
      let versionInfo = await AppVersionManager.shared.getVersionInfo()
      let version = "v\(versionInfo.appStore)/v\(versionInfo.current)"
      await send(.configVersionInfo(version, versionInfo.updateNeeded))
    }
  }
}

