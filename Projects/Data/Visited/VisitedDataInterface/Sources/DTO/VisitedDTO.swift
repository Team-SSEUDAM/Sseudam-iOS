//
//  VisitedDto.swift
//
//  Visited
//
//  Created by JiYeon
//

import Foundation
import NetworkKit
import VisitedDomainInterface
import Utility

public struct VisitedDTO: DTO {
  let id: Int
  let spotId: Int
  let userId: Int
  let site: String
  let visitedAt: String
  let isToday: Bool
  
  public func toEntity() throws -> VisitedCompleteEntity {
    return .init(
      visitedAt: visitedAt.toDateFromISO8601,
      isTodayFirst: isToday
    )
  }
}
