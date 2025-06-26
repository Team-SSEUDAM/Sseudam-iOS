//
//  TrashSpotEntity.swift
//
//  TrashSpotDomainInterface
//
//  Created by JiYeon
//

import Foundation
import DesignKit

public struct TrashSpot: Equatable, Sendable {
  public let id: Int
  public let name: String
  public let region: String
  public let address: String
  public let location: MapPoint
  public let trashType: TrashType
  
  public init(
    id: Int,
    name: String,
    region: String,
    address: String,
    location: MapPoint,
    trashType: TrashType
  ) {
    self.id = id
    self.name = name
    self.region = region
    self.address = address
    self.location = location
    self.trashType = trashType
  }
}

public struct MapPoint: Equatable, Sendable {
  public var latitude: Double
  public var longitude: Double
  
  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
}
