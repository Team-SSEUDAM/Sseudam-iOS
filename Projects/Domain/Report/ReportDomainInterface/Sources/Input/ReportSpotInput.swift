//
//  ReportRepository.swift
//
//  ReportDomainInterface
//
//  Created by yongin
//

import Foundation
import Utility
import NMReverseGeocodingDomainInterface

public struct ReportSpotInput: Codable, Equatable {
  public let spotId: Int
  
  public let spotName: String
  public let latitude: Double?
  public let longitude: Double?
  public let region: String?
  public let city: String?
  public let site: String?
  public let trashType: String
  
  public init(
    spotId: Int,
    spotName: String,
    centerPoint: Coordinates?,
    nmReverseGeoCode: NMGeoCodeReverseEntity?,
    trashType: String
  ) {
    self.spotId = spotId
    self.spotName = spotName
    self.latitude = centerPoint?.latitude
    self.longitude = centerPoint?.longitude
    self.region = nmReverseGeoCode?.region
    self.city = nmReverseGeoCode?.city
    self.site = nmReverseGeoCode?.site
    self.trashType = trashType
  }
}
