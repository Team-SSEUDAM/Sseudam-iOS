//
//  TrashSpotFlattenDetailEntity.swift
//  TrashSpotDomainInterface
//
//  Created by 조용인 on 7/8/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import DesignKit
import Utility

public struct TrashSpotFlattenDetailEntity: Equatable, Sendable {
  public var id: Int
  public var latitude: Double
  public var longitude: Double
  public var spotName: String
  public var region: String
  public var city: String
  public var site: String
  public var trashType: String
  
  public init(
    id: Int,
    latitude: Double,
    longitude: Double,
    spotName: String,
    region: String,
    city: String,
    site: String,
    trashType: String
  ) {
    self.id = id
    self.latitude = latitude
    self.longitude = longitude
    self.spotName = spotName
    self.region = region
    self.city = city
    self.site = site
    self.trashType = trashType
  }
}
