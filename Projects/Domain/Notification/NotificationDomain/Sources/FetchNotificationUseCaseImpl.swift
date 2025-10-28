//
//  FetchNotificationUseCaseImpl.swift
//  NotificationDomain
//
//  Created by Jiyeon on 10/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NotificationDomainInterface

extension FetchNotificationUseCase {
  public static func live(repository: NotificationRepository) -> FetchNotificationUseCase {
    .init { parameter in
      try await repository.fetchNotification(parameter)
    }
  }
}
