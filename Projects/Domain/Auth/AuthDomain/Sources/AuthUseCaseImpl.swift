//
//  AuthUseCaseImpl.swift
//
//  AuthDomain
//
//  Created by JiYeon
//

import Foundation
import AuthDomainInterface

extension AuthUseCase {
  public static func live(repository: AuthRepository) -> AuthUseCase {
    .init {
      try await repository.fetchData()
    }
  }
}
