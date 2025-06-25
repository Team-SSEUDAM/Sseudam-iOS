//
//  UserUseCaseImpl.swift
//
//  UserDomain
//
//  Created by JiYeon
//

import Foundation
import UserDomainInterface

extension UserUseCase {
  public static func live(repository: UserRepository) -> UserUseCase {
    .init {
      try await repository.fetchData()
    }
  }
}
