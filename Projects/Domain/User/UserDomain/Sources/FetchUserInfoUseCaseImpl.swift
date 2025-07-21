//
//  FetchUserInfoUseCaseImpl.swift
//  UserDomain
//
//  Created by Jiyeon on 7/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import UserDomainInterface

extension FetchUserInfoUseCase {
  public static func live(repository: UserRepository) -> FetchUserInfoUseCase {
    .init {
      try await repository.fetchUserInfo()
    }
  }
}
