//
//  TrashSpotDetailDTO.swift
//  TrashSpotDataInterface
//
//  Created by Jiyeon on 7/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import TrashSpotDomainInterface
import NetworkKit
import DesignKit

public struct TrashSpotDetailDTO: DTO {
  public let id: Int
  public let suggestionerId: Int
  public let suggestionerName: String
  public let name: String
  public let region: String
  public let address: AddressDTO
  public let point: PointDTO
  public let trashType: String
  public let visitedCount: Int
  public let imageUrl: String
  public let updatedAt: String
  
  public func toEntity() throws -> TrashSpotDetail {
    let address: String = try address.toEntity().address
    let point: MapPoint = try point.toEntity()
    return .init(
      id: id,
      suggestionerId: suggestionerId,
      suggestionerName: suggestionerName,
      name: name,
      address: address,
      point: point,
      trashType: TrashType(rawValue: trashType) ?? .general,
      visitedCount: visitedCount,
      imageUrl: imageUrl
    )
  }
}
