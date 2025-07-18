//
//  NMReverseGeoCodeQuery.swift
//  NMReverseGeocodingDataInterface
//
//  Created by 조용인 on 6/29/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NMReverseGeocodingDomainInterface

public struct NMReverseGeoCodeQuery: Codable {
  
  public let coords: String
  public let orders: String
  public let output: String
  
  public init(_ input: NMReverseGeoCodeInput) {
    self.coords = "\(input.longitude),\(input.latitude)"
    self.orders = "admcode,legalcode,addr,roadaddr"
    self.output = "json"
  }
}
