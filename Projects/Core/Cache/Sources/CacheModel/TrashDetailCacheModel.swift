//
//  TrashDetailCacheModel.swift
//  Cache
//
//  Created by Jiyeon on 8/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility

public struct TrashDetailCacheModel: Sendable, Equatable, Codable {
  public var id: Int
  public var suggestionerId: Int?
  public var suggestionerName: String?
  public var name: String
  public var address: String
  public var point: Coordinates
  public var trashType: String
  public var visitedCount: Int
  public var imageUrl: String?
  public var isPublicData: Bool
  
  public init(
    id: Int,
    suggestionerId: Int?,
    suggestionerName: String?,
    name: String,
    address: String,
    point: Coordinates,
    trashType: String,
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
    self.isPublicData = imageUrl == .none
  }
}
