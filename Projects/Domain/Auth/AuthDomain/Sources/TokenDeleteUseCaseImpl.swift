//
//  TokenDeleteUseCaseImpl.swift
//  AuthDomain
//
//  Created by Jiyeon on 7/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import AuthDomainInterface
import UserDefaults
import KeyChain

extension TokenDeleteUseCase {
  public static var live: TokenDeleteUseCase {
    .init {
      UserDefaultsKeys.isLoggedIn = false
      UserDefaultsKeys.accessToken = nil
      KeyChainService.delete(forKey: .refreshToken)
    }
  }
}
