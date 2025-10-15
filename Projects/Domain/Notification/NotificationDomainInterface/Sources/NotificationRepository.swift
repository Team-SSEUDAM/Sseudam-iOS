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
  public var readNotification: @Sendable(_ userId: Int, _ notiId: Int) async throws -> Void

  public init(
    fetchNotification: @Sendable @escaping (FetchNotificationParameter) async throws -> NotificationListEntity?,
    readNotification: @Sendable @escaping (_ userId: Int, _ notiId: Int) async throws -> Void
  ) {
    self.fetchNotification = fetchNotification
    self.readNotification = readNotification
  }
}
