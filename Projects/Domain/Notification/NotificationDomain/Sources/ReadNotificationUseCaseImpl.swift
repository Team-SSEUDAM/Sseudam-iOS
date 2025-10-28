//
//  ReadNotificationUseCaseImpl.swift
//  NotificationDomain
//
//  Created by Jiyeon on 10/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NotificationDomainInterface

extension ReadNotificationUseCase {
  public static func live(repository: NotificationRepository) -> ReadNotificationUseCase {
    .init { userId, notiId in
      try await repository.readNotification(userId, notiId)
    }
  }
}
