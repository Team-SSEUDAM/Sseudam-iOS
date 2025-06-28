//
//  NMReverseGeocodingUseCaseImpl.swift
//
//  NMReverseGeocodingDomain
//
//  Created by yongin
//

import Foundation
import NMReverseGeocodingDomainInterface

extension NMReverseGeocodingUseCase {
  public static func live(repository: NMReverseGeocodingRepository) -> NMReverseGeocodingUseCase {
    .init {
      try await repository.fetchData()
    }
  }
}
