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
        .init(id: 2, userId: 30, type: .approveReport, parameterValue: 0, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 3, userId: 30, type: .rejectReport, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 4, userId: 30, type: .approveSuggestion, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 5, userId: 30, type: .approveReport, parameterValue: 0, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 6, userId: 30, type: .rejectReport, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 7, userId: 30, type: .approveSuggestion, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 8, userId: 30, type: .approveReport, parameterValue: 0, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 9, userId: 30, type: .rejectReport, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 10, userId: 30, type: .approveSuggestion, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 11, userId: 30, type: .approveReport, parameterValue: 0, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 12, userId: 30, type: .rejectReport, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 13, userId: 30, type: .approveSuggestion, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 14, userId: 30, type: .approveReport, parameterValue: 0, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 15, userId: 30, type: .rejectReport, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 16, userId: 30, type: .approveSuggestion, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 17, userId: 30, type: .approveReport, parameterValue: 0, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 18, userId: 30, type: .rejectReport, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 19, userId: 30, type: .approveSuggestion, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 20, userId: 30, type: .approveReport, parameterValue: 0, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 21, userId: 30, type: .rejectReport, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 22, userId: 30, type: .approveSuggestion, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 23, userId: 30, type: .approveReport, parameterValue: 0, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 24, userId: 30, type: .rejectReport, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 25, userId: 30, type: .approveSuggestion, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 26, userId: 30, type: .approveReport, parameterValue: 0, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 27, userId: 30, type: .rejectReport, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 28, userId: 30, type: .approveSuggestion, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 29, userId: 30, type: .approveReport, parameterValue: 0, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308"),
        .init(id: 30, userId: 30, type: .rejectReport, parameterValue: 5602, topic: "", contents: "승인..", readStatus: false, createdAt: "2025-10-11T15:54:06.308")
      ])
    }
  }
}
