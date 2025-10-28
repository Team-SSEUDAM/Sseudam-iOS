//
//  UpdateFCMTokenUseCaseImpl.swift
//  UserDomain
//
//  Created by 조용인 on 10/8/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import UserDomainInterface

extension UpdateFCMTokenUseCase {
  public static func live(repository: UserRepository) -> UpdateFCMTokenUseCase {
    .init { fcmToken in
      try await repository.putFCMToken(fcmToken)
    }
  }
}
