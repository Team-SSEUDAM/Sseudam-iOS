//
//  HomeEntity.swift
//
//  HomeDomainInterface
//
//  Created by JiYeon
//

import Foundation
import CoreLocation

public struct TrashListEntity: Equatable, Sendable {
  var list: [TrashItem]
}

public struct TrashItem: Equatable, Sendable {
  public var id: Int
  public var name: String
  public var region: String
  public var point: MapPoint
  public var trashType: TrashType
  
}

public enum TrashType: String, Sendable {
  case recycle = "RECYCLE"
  case general = "GENERAL"
}

public struct MapPoint: Equatable, Sendable {
  public var latitude: Double
  public var longitude: Double
  
  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
}
