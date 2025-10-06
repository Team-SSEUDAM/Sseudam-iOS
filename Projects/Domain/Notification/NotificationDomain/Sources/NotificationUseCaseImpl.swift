//
//  NotificationUseCaseImpl.swift
//
//  NotificationDomain
//
//  Created by Jiyeon
//

import Foundation
import NotificationDomainInterface

extension NotificationUseCase {
  public static func live(repository: NotificationRepository) -> NotificationUseCase {
    .init {
      try await repository.fetchData()
    }
  }
}
