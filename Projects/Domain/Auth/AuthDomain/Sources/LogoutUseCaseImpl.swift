//
//  LogoutUseCaseImpl.swift
//  AuthDomain
//
//  Created by Jiyeon on 7/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import AuthDomainInterface

extension LogoutUseCase {
  public static func live(repository: AuthRepository) -> LogoutUseCase {
    .init {
      try await repository.logout()
    }
  }
}
