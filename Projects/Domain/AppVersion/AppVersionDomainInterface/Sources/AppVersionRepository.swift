//
//  AppVersionRepository.swift
//
//  AppVersionDomainInterface
//
//  Created by yongin
//

import Foundation

public struct AppVersionRepository {
  public var checkAppVersion: @Sendable () async throws -> AppVersionEntity

  public init(
    checkAppVersion: @Sendable @escaping () async throws -> AppVersionEntity
  ) {
    self.checkAppVersion = checkAppVersion
  }
}
