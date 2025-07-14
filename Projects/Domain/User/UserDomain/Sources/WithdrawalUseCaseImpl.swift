//
//  WithdrawalUseCaseImpl.swift
//  UserDomain
//
//  Created by Jiyeon on 7/13/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import UserDomainInterface

extension WithdrawalUseCase {
  public static func live(repository: UserRepository) -> WithdrawalUseCase {
    .init {
      try await repository.withdrawal()
    }
  }
}
