//
//  TokenSaveUseCaseImpl.swift
//  AuthDomain
//
//  Created by Jiyeon on 6/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import AuthDomainInterface
import UserDefaults
import KeyChain

extension TokenSaveUseCase {
  public static func live() -> TokenSaveUseCase {
    .init { result in
      UserDefaultsKeys.isLoggedIn = !result.isTempToken
      UserDefaultsKeys.accessToken = result.accessToken
      KeyChainService.save(result.refreshToken, forKey: .refreshToken)
    }
  }
}
