//
//  NotificationEndpoint.swift
//  NotificationDataInterface
//
//  Created by Jiyeon on 10/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit
import UserDefaults
import NotificationDomainInterface

public enum NotificationEndpoint: Sendable {
  public static func fetchNotification(parameter: FetchNotificationParameter) -> Endpoint<NotificationListDTO> {
    return Endpoint(
      headers: .authorization(UserDefaultsKeys.accessToken),
      method: .get,
      path: "/notifications",
      parameters: .query(parameter)
    )
  }
}
