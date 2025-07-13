//
//  VisitedRepository.swift
//
//  VisitedDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct VisitedRepository {
  public var fetchData: @Sendable () async throws -> Void

  public init(fetchData: @Sendable @escaping () async throws -> Void) {
    self.fetchData = fetchData
  }
}
