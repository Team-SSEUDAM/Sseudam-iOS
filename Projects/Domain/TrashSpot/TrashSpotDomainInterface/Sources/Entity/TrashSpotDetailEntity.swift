//
//  TrashSpotDetailEntity.swift
//  TrashSpotDomainInterface
//
//  Created by Jiyeon on 7/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import DesignKit
import Utility
import Cache

public struct TrashSpotDetail: Equatable, Sendable {
  public var id: Int
  public var suggestionerId: Int?
  public var suggestionerName: String?
  public var name: String
  public var address: String
  public var point: Coordinates
  public var trashType: TrashType
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
    self.isPublicData = imageUrl == .none
  }
  
  public init(_ cacheModel: TrashDetailCacheModel) {
    self.id = cacheModel.id
    self.suggestionerId = cacheModel.suggestionerId
    self.suggestionerName = cacheModel.suggestionerName
    self.name = cacheModel.name
    self.address = cacheModel.address
    self.point = cacheModel.point
    self.trashType = TrashType(rawValue: cacheModel.trashType) ?? .general
    self.visitedCount = cacheModel.visitedCount
    self.imageUrl = cacheModel.imageUrl
    self.isPublicData = cacheModel.imageUrl == .none
  }
  
  public func makeCacheModel() -> TrashDetailCacheModel {
    return .init(
      id: self.id,
      suggestionerId: self.suggestionerId,
      suggestionerName: self.suggestionerName,
      name: self.name,
      address: self.address,
      point: self.point,
      trashType: self.trashType.rawValue,
      visitedCount: self.visitedCount,
      imageUrl: self.imageUrl
    )
  }
}
