//
//  NMGeoCodeReverseEntity.swift
//  ReportDomainInterface
//
//  Created by 조용인 on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct NMGeoCodeReverseEntity {
  public let area1: String
  public let area2: String
  public let area3: String
  public let area4: String?
  public let roadAddress: String?
  public let zipCode: String?
  
  public init(
    area1: String,
    area2: String,
    area3: String,
    area4: String?,
    roadAddress: String?,
    zipCode: String?
  ) {
    self.area1 = area1
    self.area2 = area2
    self.area3 = area3
    self.area4 = area4
    self.roadAddress = roadAddress
    self.zipCode = zipCode
  }
}
