//
//  MapPointDTO.swift
//  TrashSpotDataInterface
//
//  Created by Jiyeon on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import TrashSpotDomainInterface
import NetworkKit
import Utility

public struct PointDTO: DTO {
  public let type: String
  public let coordinates: [Double] // [longitude, latitude]
  
  public func toEntity() throws -> Coordinates {
    return .init(latitude: coordinates[1], longitude: coordinates[0])
  }
}
