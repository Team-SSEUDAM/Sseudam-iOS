//
//  NotificationRepositoryImpl.swift
//
//  Notification
//
//  Created by Jiyeon
//

import Foundation
import NotificationDomainInterface
import NotificationDataInterface
import NetworkKit

public extension NotificationRepository {
  static func live(networker: NetworkKit) -> NotificationRepository {
    NotificationRepository { parameter in
      let endPoint = NotificationEndpoint.fetchNotification(parameter: parameter)
      return try await networker.execute(with: endPoint).toEntity()
    }
  }
}
