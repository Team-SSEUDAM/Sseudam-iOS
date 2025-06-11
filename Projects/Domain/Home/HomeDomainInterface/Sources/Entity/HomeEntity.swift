//
//  HomeEntity.swift
//
//  HomeDomainInterface
//
//  Created by JiYeon
//

import Foundation
import CoreLocation

public struct TrashItem: Equatable, Sendable {
  public var id: Int
  public var name: String
  public var region: String
  public var address: String
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

public let sampleData: [TrashItem] = [
  .init(id: 1, name: "1", region: "SEOUL", address: "서울", point: .init(latitude: 37.644012, longitude: 126.919528), trashType: .general),
  .init(id: 2, name: "2", region: "SEOUL", address: "서울", point: .init(latitude: 37.642912, longitude: 126.921028), trashType: .general),
  .init(id: 3, name: "3", region: "SEOUL", address: "서울", point: .init(latitude: 37.643812, longitude: 126.920828), trashType: .general),
  .init(id: 4, name: "4", region: "SEOUL", address: "서울", point: .init(latitude: 37.642712, longitude: 126.919928), trashType: .general),
  .init(id: 5, name: "5", region: "SEOUL", address: "서울", point: .init(latitude: 37.644412, longitude: 126.920128), trashType: .general),
  .init(id: 6, name: "6", region: "SEOUL", address: "서울", point: .init(latitude: 37.643112, longitude: 126.920928), trashType: .general)
  
]
