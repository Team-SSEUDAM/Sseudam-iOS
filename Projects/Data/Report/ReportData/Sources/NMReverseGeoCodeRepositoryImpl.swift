//
//  NMReverseGeoCodeRepositoryImpl.swift
//  ReportData
//
//  Created by 조용인 on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit
import ReportDomainInterface
import ReportDataInterface

public extension NMReverseGeoCodeRepository {
  static var live: NMReverseGeoCodeRepository {
    NMReverseGeoCodeRepository(
      reverseGeoCode: { input in
        let query = NMReverseGeoCodeQuery(input)
        let endpoint = NMReverseGeoCodeEndpoint.reverseGeocoda(query: query)
        let result = try await NetworkKit().execute(with: endpoint)
        return try result.toEntity()
      }
    )
  }
}
