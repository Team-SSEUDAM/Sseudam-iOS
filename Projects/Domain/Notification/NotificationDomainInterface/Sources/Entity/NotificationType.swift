//
//  NotificationType.swift
//  NotificationDomainInterface
//
//  Created by Jiyeon on 10/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public enum NotificationType: String, Sendable, Equatable {
  case approveSuggestion = "APPROVE_SUGGESTION"
  case rejectSuggestion = "REJECT_SUGGESTION"
  case approveReport = "APPROVE_REPORT"
  case rejectReport = "REJECT_REPORT"
  case newPetSeason = "NEW_PET_SEASON"
  case visitedSpot = "ANONYMOUS_VISITED_SPOT"
  case adminPush = "ADMIN_PUSH"
  case regular = "REGULAR"
}
