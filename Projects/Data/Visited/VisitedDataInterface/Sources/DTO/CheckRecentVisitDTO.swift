//
//  CheckRecentVisitDTO.swift
//  VisitedDataInterface
//
//  Created by Jiyeon on 7/19/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit
import VisitedDomainInterface
import Utility


public struct CheckRecentVisitDTO: DTO {
  public let spotId: Int
  public let userId: Int
  public let lastVisitedAt: String
  
  public init(spotId: Int, userId: Int, lastVisitedAt: String) {
    self.spotId = spotId
    self.userId = userId
    self.lastVisitedAt = lastVisitedAt
  }
  
  public func toEntity() throws -> CheckRecentVisitEntity {
    let lastVisitedAt: Date? = lastVisitedAt.toDateFromISO8601
    let expiredAt: Date? = lastVisitedAt?.addingTimeInterval(300)
    var isExpired: Bool = true
    if let expiredAt = expiredAt {
      isExpired =  expiredAt.remainingFromNow() == nil
    }
    return .init(expiredAt: expiredAt, isExpired: isExpired)
  }
}
