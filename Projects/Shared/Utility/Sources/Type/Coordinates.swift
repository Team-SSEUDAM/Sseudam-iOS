//
//  Coordinates.swift
//  Utility
//
//  Created by 조용인 on 6/29/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import CoreLocation

public struct Coordinates: Sendable, Codable, Equatable {
  public let latitude: Double
  public let longitude: Double
  
  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
  
  public static func == (lhs: Coordinates, rhs: Coordinates) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
  }
}

extension Coordinates {
  public func distance(to other: Coordinates) -> Double {
    let loc1 = CLLocation(latitude: latitude, longitude: longitude)
    let loc2 = CLLocation(latitude: other.latitude, longitude: other.longitude)
    return loc1.distance(from: loc2)
  }
}
