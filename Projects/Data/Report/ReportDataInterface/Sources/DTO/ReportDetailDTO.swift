//
//  ReportDetailDTO.swift
//  ReportDataInterface
//
//  Created by Jiyeon on 10/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit
import ReportDomainInterface
import Utility

public struct ReportDetailDTO: DTO {
  public typealias Entity = ReportDetailEntity
  
  public let id: Int
  public let spotId: Int
  public let spotName: String
  public let region: String
  public let userId: Int
  public let reportType: String
  public let point: ReportPointDTO
  public let address: ReportAddressDTO
  public let trashType: String
  public let imageUrl: String
  public let status: String
  public let rejectReason: String?
  public let createdAt: String
  
  
  public func toEntity() throws -> Entity {
    let address: String = try address.toEntity()
    let point: Coordinates = try point.toEntity()
    return .init(
      id: id,
      spotId: spotId,
      spotName: spotName,
      point: point,
      address: address,
      status: .init(rawValue: status) ?? .pending,
      rejectReason: rejectReason ?? ""
    )
  }
}
