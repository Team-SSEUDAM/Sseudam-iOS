//
//  NMReverseGeoCodeUseCaseImpl.swift
//  NMReverseGeocodingDomain
//
//  Created by 조용인 on 6/29/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NMReverseGeocodingDomainInterface

extension NMReverseGeoCodeUseCase {
  public static func live(
    repository: NMReverseGeoCodeRepository
  ) -> NMReverseGeoCodeUseCase {
    .init { input in
      let entity = try await repository.reverseGeoCode(input)
      return entity
    }
  }
}
