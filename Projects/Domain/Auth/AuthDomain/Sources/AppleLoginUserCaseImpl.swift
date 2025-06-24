//
//  AppleLoginUserCaseImpl.swift
//  AuthDomain
//
//  Created by Jiyeon on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import AuthDomainInterface

extension AppleLoginUseCase {
  public static func test(repository: AuthRepository) -> AppleLoginUseCase {
    .init { token in
      try await repository.requestAppleLogin(token)
    }
  }
  
  
}
