//
//  SuggestionUseCaseImpl.swift
//
//  SuggestionDomain
//
//  Created by yongin
//

import Foundation
import SuggestionDomainInterface

extension SpotSuggestionUseCase {
  public static func live(repository: SpotSuggestionRepository) -> SpotSuggestionUseCase {
    .init { spotname, centerPoint, nmReverseGeoCode, trashType in
      let input = SpotSuggestionInput(
        spotName: spotname,
        centerPoint: centerPoint,
        nmReverseGeoCode: nmReverseGeoCode,
        trashType: trashType
      )
      let entity = try await repository.postSpotSuggestion(input)
      return entity.imageUploadURL
    }
  }
}
