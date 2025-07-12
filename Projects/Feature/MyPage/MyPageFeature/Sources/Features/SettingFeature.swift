//
//  SettingFeature.swift
//  MyPageFeature
//
//  Created by Jiyeon on 7/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ComposableArchitecture
import AuthDomainInterface

import Utility
import UserDefaults
import DesignKit

@Reducer
public struct SettingFeature {
  
  public init() { }
  
  @ObservableState
  public struct State: Equatable {
    var isLoggedIn: Bool = true
    var isNotiOn: Bool = true
    public var version: String = ""
    public var isNeedUpdate: Bool = false
    public var alertType: AlertType? = nil
    public var toastMessage: String? = nil
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
    case initialLoginData
    case withdrawal
    case withdrawalResult(Result<EmptyEquatable, NetworkError>)
    
    case feedback
    case serviceTerm
    case privacyTerm
    case appstore
    
    case alertCancelTapped
    case alertAcceptTapped(AlertType)
    case clearAlertState
    case showToastMessage(String)
    
    case pop
    case delegate(Delegate)
  }
  
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    
  }
  
  public enum Delegate: Equatable {
    case pop
  }
  
  @Dependency(\.LogoutUseCase) var logoutUseCase
  @Dependency(\.TokenDeleteUseCase) var tokenDeleteUseCase
  @Dependency(\.WithdrawalUseCase) var withdrawalUseCase
  @Dependency(\.openURL) var openURL

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
        state.isLoggedIn = true //UserDefaultsKeys.isLoggedIn ?? false
        return .none
        
      case .notiAllow:
        return .none
        
      case .logout:
        state.alertType = .logout
        return .none
        
      case .initialLoginData:
        return handleLogoutCompletion()
        
      case .withdrawal:
        state.alertType = .withdrawal
        return .none
        
      case .withdrawalResult(.success):
        return handleLogoutCompletion()
        
      case let .withdrawalResult(.failure(error)):
        return .send(.showToastMessage(error.localizedDescription))
        
      case .feedback:
        return openExternalLink(url: ExternalURL.feedBack)
        
      case .serviceTerm:
        return openExternalLink(url: ExternalURL.serviceTerm)
        
      case .privacyTerm:
        return openExternalLink(url: ExternalURL.privacyTerm)
        
      case .appstore:
        if state.isNeedUpdate {
          return openExternalLink(url: ExternalURL.appStore)
        } else {
          return .none
        }
        
      case .alertCancelTapped:
        return .send(.clearAlertState)
        
      case .alertAcceptTapped(.logout):
        return .none
        
      case .alertAcceptTapped(.withdrawal):
        return .none
        
      case .clearAlertState:
        state.alertType = nil
        return .none
        
      case .pop:
        return .send(.delegate(.pop))
        
      default: return .none
      }
    }
  }
  
}

extension SettingFeature {
  
  private func openExternalLink(url: URL?) -> Effect<Action> {
    return .run { send in
      if let url = url {
        await openURL(url)
      }
    }
  }
  
  private func handleLogoutCompletion() -> Effect<Action> {
    return .run { send in
      await tokenDeleteUseCase.execute()
      await send(.checkLoggedIn)
    }
  }
  
  private func requestLogout() -> Effect<Action> {
    return .run { send in
      do {
        try await logoutUseCase.execute()
        await send(.initialLoginData)
      } catch {
        await send(.initialLoginData)
      }
    }
  }
  
  private func requestWithdrawal() -> Effect<Action> {
    return .run { send in
      do {
        try await withdrawalUseCase.execute()
        await send(.withdrawalResult(.success(.value)))
      } catch let error as NetworkError {
        await send(.withdrawalResult(.failure(error)))
      } catch {
        await send(.withdrawalResult(.failure(.customError(message: error.localizedDescription))))
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

