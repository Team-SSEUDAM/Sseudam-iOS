//
//  MapPoint+.swift
//  HomeFeature
//
//  Created by Jiyeon on 6/30/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import CoreLocation
import TrashSpotDomainInterface

extension MapPoint {
  public func distance(to other: MapPoint) -> Double {
    let loc1 = CLLocation(latitude: latitude, longitude: longitude)
    let loc2 = CLLocation(latitude: other.latitude, longitude: other.longitude)
    return loc1.distance(from: loc2)
  }
}
