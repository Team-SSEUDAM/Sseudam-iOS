//
//  HomeEntity.swift
//
//  HomeDomainInterface
//
//  Created by JiYeon
//

import Foundation
import CoreLocation
import DesignKit

public struct TrashItem: Equatable, Sendable {
  public var id: Int
  public var name: String
  public var region: String
  public var address: String
  public var point: MapPoint
  public var trashType: TrashType
  
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

public let sampleData2: [TrashItem] = [
  .init(id: 7, name: "7", region: "SEOUL", address: "서울", point: .init(latitude: 37.646512, longitude: 126.917528), trashType: .general),
  .init(id: 8, name: "8", region: "SEOUL", address: "서울", point: .init(latitude: 37.641512, longitude: 126.924028), trashType: .general),
  .init(id: 9, name: "9", region: "SEOUL", address: "서울", point: .init(latitude: 37.645812, longitude: 126.923328), trashType: .general),
  .init(id: 10, name: "10", region: "SEOUL", address: "서울", point: .init(latitude: 37.640912, longitude: 126.918928), trashType: .general),
  .init(id: 11, name: "11", region: "SEOUL", address: "서울", point: .init(latitude: 37.647312, longitude: 126.920528), trashType: .general),
  .init(id: 12, name: "12", region: "SEOUL", address: "서울", point: .init(latitude: 37.642312, longitude: 126.926128), trashType: .general)
  
]
