//
//  ReportDetailEntity.swift
//  ReportDomainInterface
//
//  Created by Jiyeon on 10/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility

public struct ReportDetailEntity: Sendable, Equatable, Identifiable {
  public let id: Int
  public let spotId: Int
  public let spotName: String
  public let point: Coordinates
  public let address: String
  public let status: ApprovalStatus
  public let rejectReason: String
  
  public init(
    id: Int,
    spotId: Int,
    spotName: String,
    point: Coordinates,
    address: String,
    status: ApprovalStatus,
    rejectReason: String
  ) {
    self.id = id
    self.spotId = spotId
    self.spotName = spotName
    self.point = point
    self.address = address
    self.status = status
    self.rejectReason = rejectReason
  }
}
