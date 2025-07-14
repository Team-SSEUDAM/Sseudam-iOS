//
//  ReportRepository.swift
//
//  ReportDomainInterface
//
//  Created by yongin
//

import Foundation
import Utility
import TrashSpotDomainInterface

public struct ReportSpotInput: Codable, Equatable {
  public let spotId: Int
  public let reportType: String
  public let spotName: String
  public let latitude: Double?
  public let longitude: Double?
  public let region: String?
  public let city: String?
  public let site: String?
  public let trashType: String
  
  public init(
    reportType: String,
    spotDetail: TrashSpotFlattenDetailEntity?
  ) {
    self.reportType = reportType
    self.spotId = spotDetail?.id ?? 0
    self.spotName = spotDetail?.spotName ?? ""
    self.latitude = spotDetail?.latitude
    self.longitude = spotDetail?.longitude
    self.region = spotDetail?.region
    self.city = spotDetail?.city
    self.site = spotDetail?.site
    self.trashType = spotDetail?.trashType ?? ""
  }
}
