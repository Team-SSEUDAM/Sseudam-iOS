//
//  TrashSpotDetailEntity.swift
//  TrashSpotDomainInterface
//
//  Created by Jiyeon on 7/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import DesignKit

public struct TrashSpotDetail: Equatable, Sendable {
  public let id: Int
  public let suggestionerId: Int?
  public let suggestionerName: String?
  public let name: String
  public let address: String
  public let point: MapPoint
  public let trashType: TrashType
  public let visitedCount: Int
  public let imageUrl: String?
  
  public init(
    id: Int,
    suggestionerId: Int?,
    suggestionerName: String?,
    name: String,
    address: String,
    point: MapPoint,
    trashType: TrashType,
    visitedCount: Int,
    imageUrl: String?
  ) {
    self.id = id
    self.suggestionerId = suggestionerId
    self.suggestionerName = suggestionerName
    self.name = name
    self.address = address
    self.point = point
    self.trashType = trashType
    self.visitedCount = visitedCount
    self.imageUrl = imageUrl
  }
}
