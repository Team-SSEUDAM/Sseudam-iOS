//
//  NMReverseGeoCodeRepository.swift
//  NMReverseGeocodingDomainInterface
//
//  Created by 조용인 on 6/29/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct NMReverseGeoCodeRepository {
  public var reverseGeoCode: @Sendable (_ input: NMReverseGeoCodeInput) async throws -> NMGeoCodeReverseEntity
  
  public init(
    reverseGeoCode: @Sendable @escaping (
      _ input: NMReverseGeoCodeInput
    ) async throws -> NMGeoCodeReverseEntity
  ) {
    self.reverseGeoCode = reverseGeoCode
  }
}
