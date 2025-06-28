//
//  NMReverseGeocodingRepositoryImpl.swift
//
//  NMReverseGeocoding
//
//  Created by yongin
//

import Foundation
import NMReverseGeocodingDomainInterface
import NMReverseGeocodingDataInterface
import Core

public extension NMReverseGeocodingRepository {
  static var live: NMReverseGeocodingRepository {
    NMReverseGeocodingRepository(
      fetchData: {
        // 실제 네트워크 작업 구현
        return
      }
    )
  }
}
