//
//  MapPointEntity.swift
//  TrashSpotDomainInterface
//
//  Created by Jiyeon on 6/29/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct MapPoint: Equatable, Sendable {
  public var latitude: Double
  public var longitude: Double
  
  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
}
