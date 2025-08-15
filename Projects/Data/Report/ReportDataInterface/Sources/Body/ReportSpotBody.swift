//
//  ReportSpotBody.swift
//  ReportDataInterface
//
//  Created by 조용인 on 6/29/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ReportDomainInterface

public struct ReportSpotBody: Encodable, Equatable {
  public let reportType: String
  public let spotName: String?
  public let latitude: Double?
  public let longitude: Double?
  public let region: String?
  public let city: String?
  public let site: String?
  public let trashType: String?
  
  public init(
    _ input: ReportSpotInput
  ) {
    self.reportType = input.reportType
    self.spotName = input.spotName
    self.latitude = input.latitude
    self.longitude = input.longitude
    self.region = input.region
    self.city = input.city
    self.site = input.site
    self.trashType = input.trashType
  }
}
