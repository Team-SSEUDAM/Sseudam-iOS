//
//  VisitedCompleteEntity.swift
//  VisitedDomainInterface
//
//  Created by Jiyeon on 7/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct VisitedCompleteEntity: Equatable {
  public let visitedAt: Date?
  public let isTodayFirst: Bool
  
  public init(
    visitedAt: Date?,
    isTodayFirst: Bool
  ) {
    self.visitedAt = visitedAt
    self.isTodayFirst = isTodayFirst
  }
}
