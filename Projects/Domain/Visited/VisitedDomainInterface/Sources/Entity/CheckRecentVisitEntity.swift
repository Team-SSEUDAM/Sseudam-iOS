//
//  CheckRecentVisitEntity.swift
//  VisitedDomainInterface
//
//  Created by Jiyeon on 7/19/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct CheckRecentVisitEntity: Equatable {
  public let expiredAt: Date?
  public let isExpired: Bool
  
  public init(expiredAt: Date?, isExpired: Bool) {
    self.expiredAt = expiredAt
    self.isExpired = isExpired
  }
}
