//
//  NMReverseGeoCodeEndpoint.swift
//  NMReverseGeocodingDataInterface
//
//  Created by 조용인 on 6/29/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility
import NetworkKit

public struct NMReverseGeoCodeEndpoint: Sendable {
  public static func reverseGeocoda(
    query: NMReverseGeoCodeQuery
  ) -> Endpoint<NMReverseGeoCodeDTO> {
    return Endpoint(
      headers: .custom([
        "X-NCP-APIGW-API-KEY-ID": Constants.NM_CLIENT_ID ?? "",
        "X-NCP-APIGW-API-KEY": Constants.NM_CLIENT_SECRET ?? "",
      ]),
      method: .get,
      baseURL: "https://maps.apigw.ntruss.com/map-reversegeocode/v2",
      path: "/gc",
      parameters: .query(query),
      isNotSseudamAPI: true
    )
  }
}
