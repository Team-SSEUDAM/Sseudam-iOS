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
  static var live: NotificationRepository {
    NotificationRepository(
      fetchData: {
        // 실제 네트워크 작업 구현
        return
      }
    )
  }
}
