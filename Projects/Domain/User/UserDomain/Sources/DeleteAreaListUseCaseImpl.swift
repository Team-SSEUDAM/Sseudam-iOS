//
//  DeleteAreaListUseCaseImpl.swift
//  UserDomain
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import UserDomainInterface

extension DeleteAreaListUseCase {
  public static func live(repository: UserRepository) -> DeleteAreaListUseCase {
    .init {
      return try await repository.deleteAreaList()
    }
  }
}
