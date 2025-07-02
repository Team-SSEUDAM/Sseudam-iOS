//
//  NMReverseGeocodingRepositoryImpl.swift
//
//  NMReverseGeocoding
//
//  Created by yongin
//

import Foundation
import NetworkKit
import NMReverseGeocodingDomainInterface
import NMReverseGeocodingDataInterface

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
