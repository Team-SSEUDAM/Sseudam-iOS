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
  
  public static func test() -> FetchNotificationUseCase {
    .init { parameter in
      return .init(items: [
        .init(id: 1, userId: 30, type: .approveSuggestion, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 1, userId: 30, type: .approveReport, parameterValue: 0, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 1, userId: 30, type: .rejectReport, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308")
      ])
    }
  }
}
