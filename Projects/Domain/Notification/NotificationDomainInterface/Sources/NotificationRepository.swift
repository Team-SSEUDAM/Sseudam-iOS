//
//  NotificationRepository.swift
//
//  NotificationDomainInterface
//
//  Created by Jiyeon
//

import Foundation

public struct NotificationRepository {
  public var fetchNotification: @Sendable (FetchNotificationParameter) async throws -> NotificationListEntity?

  public init(
    fetchNotification: @Sendable @escaping (FetchNotificationParameter) async throws -> NotificationListEntity?
  ) {
    self.fetchNotification = fetchNotification
  }
}
