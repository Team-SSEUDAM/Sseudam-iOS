//
//  FetchTrashSpotParameter.swift
//  TrashSpotDomainInterface
//
//  Created by Jiyeon on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct FetchTrashSpotParameter: Encodable {
  let region: String?
  let type: String?
  let swLat: Double?
  let swLng: Double?
  let neLat: Double?
  let neLng: Double?
  
  public init(
    region: String?,
    type: String?,
    swLat: Double?,
    swLng: Double?,
    neLat: Double?,
    neLng: Double?
  ) {
    self.region = region
    self.type = type
    self.swLat = swLat
    self.swLng = swLng
    self.neLat = neLat
    self.neLng = neLng
  }
}
