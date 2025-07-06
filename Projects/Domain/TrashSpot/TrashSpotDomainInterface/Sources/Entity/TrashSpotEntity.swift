//
//  TrashSpotEntity.swift
//
//  TrashSpotDomainInterface
//
//  Created by JiYeon
//

import Foundation
import DesignKit
import Utility

public struct TrashSpot: Equatable, Sendable {
  public let id: Int
  public let name: String
  public let region: String
  public let address: String
  public let location: Coordinates
  public let trashType: TrashType
  
  public init(
    id: Int,
    name: String,
    region: String,
    address: String,
    location: Coordinates,
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
