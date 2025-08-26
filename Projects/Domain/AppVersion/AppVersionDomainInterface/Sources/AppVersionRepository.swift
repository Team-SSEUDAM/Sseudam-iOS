//
//  AppVersionRepository.swift
//
//  AppVersionDomainInterface
//
//  Created by yongin
//

import Foundation

public struct AppVersionRepository {
  public var fetchData: @Sendable () async throws -> Void

  public init(fetchData: @Sendable @escaping () async throws -> Void) {
    self.fetchData = fetchData
  }
}
