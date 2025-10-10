//
//  NotificationType.swift
//  NotificationDomainInterface
//
//  Created by Jiyeon on 10/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public enum NotificationType: Sendable, Equatable {
  case approveSuggestion
  case rejectSuggestion
  case approveReport
  case rejectReport
  case newPetSeason
  case visitedSpot
  case adminPush
  case regular
}
