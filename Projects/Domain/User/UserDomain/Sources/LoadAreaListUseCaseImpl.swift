//
//  LoadAreaListUseCaseImpl.swift
//  UserDomain
//
//  Created by Jiyeon on 6/27/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import UserDomainInterface

extension LoadAreaListUseCase {
  public static func live(repository: UserRepository) -> LoadAreaListUseCase {
    .init {
      return try await repository.loadAreaList()
    }
  }
}
