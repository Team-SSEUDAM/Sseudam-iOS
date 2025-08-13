//
//  getVisitedListUseCaseImpl.swift
//  VisitedDomain
//
//  Created by 조용인 on 8/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import VisitedDomainInterface

extension GetVisitedListUseCase {
  public static func live(repository: VisitedRepository) -> GetVisitedListUseCase {
    .init {
      try await repository.getVisitedList()
    }
  }
}
