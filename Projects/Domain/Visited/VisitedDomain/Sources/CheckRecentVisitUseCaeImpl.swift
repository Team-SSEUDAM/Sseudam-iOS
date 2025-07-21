//
//  CheckRecentVisitUseCaeImpl.swift
//  VisitedDomain
//
//  Created by Jiyeon on 7/19/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import VisitedDomainInterface

extension CheckRecentVisitUseCase {
  public static func live(repository: VisitedRepository) -> CheckRecentVisitUseCase {
    .init { userId, spotId in
      try await repository.checkRecentVisit(userId, spotId)
    }
  }
}

