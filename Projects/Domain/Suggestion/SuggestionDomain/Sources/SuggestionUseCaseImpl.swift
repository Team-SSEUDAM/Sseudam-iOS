//
//  SuggestionUseCaseImpl.swift
//
//  SuggestionDomain
//
//  Created by yongin
//

import Foundation
import SuggestionDomainInterface
import NMReverseGeocodingDomainInterface

extension SpotSuggestionUseCase {
  public static func live(repository: SpotSuggestionRepository) -> SpotSuggestionUseCase {
    .init { spotname, centerPoint, nmReverseGeoCode, trashType in
      let input = SpotSuggestionInput(
        spotName: spotname,
        centerPoint: centerPoint,
        nmReverseGeoCode: nmReverseGeoCode,
        trashType: trashType
      )
      return try await repository.postSpotSuggestion(input)
    }
  }
}
