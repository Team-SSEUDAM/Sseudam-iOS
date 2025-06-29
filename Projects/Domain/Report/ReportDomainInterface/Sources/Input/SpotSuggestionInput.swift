//
//  SpotSuggestionInput.swift
//  ReportDomainInterface
//
//  Created by 조용인 on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility
import NMReverseGeocodingDomainInterface

public struct SpotSuggestionInput: Codable, Equatable {
  public let spotName: String
  public let latitude: Double
  public let longitude: Double
  public let region: String
  public let city: String
  public let site: String
  public let trashType: String
  
  public init(
    spotName: String,
    centerPoint: Coordinates,
    nmReverseGeoCode: NMGeoCodeReverseEntity,
    trashType: String
  ) {
    self.spotName = spotName
    self.latitude = centerPoint.latitude
    self.longitude = centerPoint.longitude
    self.region = nmReverseGeoCode.region
    self.city = nmReverseGeoCode.city
    self.site = nmReverseGeoCode.site
    self.trashType = trashType
  }
}
