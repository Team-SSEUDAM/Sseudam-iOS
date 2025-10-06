//
//  NotificationRepository.swift
//
//  NotificationDomainInterface
//
//  Created by Jiyeon
//

import Foundation

public struct NotificationRepository {
  public var fetchData: @Sendable () async throws -> Void

  public init(fetchData: @Sendable @escaping () async throws -> Void) {
    self.fetchData = fetchData
  }
}
