//
//  ForceUpdateFeature.swift
//  Sseudam
//
//  Created by 조용인 on 8/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Utility
import DesignKit
import AppVersionDomainInterface

@Reducer
struct ForceUpdateFeature {
  @ObservableState
  struct State: Equatable {
    var hasCheckedUpdate = false
    let appStoreURL = URL(string: Constants.APP_STORE_URL)!
  }
  
  enum Action: Equatable {
    case delegate(Delegate)
    case onAppear
    case appWillEnterForeground
    
    case checkForUpdate
    case versionInfoResult(Result<AppVersionEntity, NetworkError>)
    
    enum Delegate: Equatable {
      case presentAlert(AlertType)
    }
  }
  
  @Dependency(\.CheckAppVersionUseCase) var checkAppVersionUseCase
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.checkForUpdate)
        
      case .appWillEnterForeground:
        guard !state.hasCheckedUpdate else { return .none } // optional이면 재확인 X
        return .send(.checkForUpdate)
        
      case .checkForUpdate:
        guard !state.hasCheckedUpdate else { return .none } // optional이면 재확인 X
        return checkAppVersion()
        
      case let .versionInfoResult(.success(versionInfo)):
        
        switch versionInfo.updateStatus {
        case .required:
          return .send(.delegate(.presentAlert(.forceAppUpdate(state.appStoreURL))))
          
        case .optional:
          state.hasCheckedUpdate = true
          return .send(.delegate(.presentAlert(.optionalAppUpdate(state.appStoreURL))))
          
        case .notNeeded:
          return .none
        }
        
      case .versionInfoResult(.failure):
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
}

extension ForceUpdateFeature {
  private func checkAppVersion() -> Effect<Action> {
    return .run { send in
      do {
        let result = try await checkAppVersionUseCase.execute()
        await send(.versionInfoResult(.success(result)))
      } catch let error as NetworkError {
        await send(.versionInfoResult(.failure(error)))
      } catch {
        await send(.versionInfoResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
}
