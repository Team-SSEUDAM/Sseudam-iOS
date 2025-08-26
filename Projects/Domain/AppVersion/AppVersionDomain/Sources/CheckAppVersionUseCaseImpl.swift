//
//  CheckAppVersionUseCaseImpl.swift
//
//  AppVersionDomain
//
//  Created by yongin
//

import Foundation
import AppVersionDomainInterface

extension CheckAppVersionUseCase {
  public static func live(repository: AppVersionRepository) -> CheckAppVersionUseCase {
    .init {
      try await repository.checkAppVersion()
    }
  }
}
