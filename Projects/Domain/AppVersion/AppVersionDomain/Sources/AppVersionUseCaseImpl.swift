//
//  AppVersionUseCaseImpl.swift
//
//  AppVersionDomain
//
//  Created by yongin
//

import Foundation
import AppVersionDomainInterface

extension AppVersionUseCase {
  public static func live(repository: AppVersionRepository) -> AppVersionUseCase {
    .init {
      try await repository.fetchData()
    }
  }
}
