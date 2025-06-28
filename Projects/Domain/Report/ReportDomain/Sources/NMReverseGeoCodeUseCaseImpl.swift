//
//  NMReverseGeoCodeUseCaseImpl.swift
//  ReportDomain
//
//  Created by 조용인 on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ReportDomainInterface

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
