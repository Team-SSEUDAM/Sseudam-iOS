//
//  WithdrawalUseCaseImpl.swift
//  AuthDomain
//
//  Created by Jiyeon on 7/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import AuthDomainInterface

extension WithdrawalUseCase {
  public static func live(repository: AuthRepository) -> WithdrawalUseCase {
    .init {
      try await repository.withdrawal()
    }
  }
}
