//
//  SpotNameValidateUseCaseImpl.swift
//  SuggestionDomain
//
//  Created by 조용인 on 6/30/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import SuggestionDomainInterface

extension SpotNameValidateUseCase {
  public static func live(repository: SpotSuggestionRepository) -> SpotNameValidateUseCase {
    .init { spotName in
      let input = SpotNameValidateInput(spotName: spotName)
      return try await repository.getSpotValidation(input)
    }
  }
}
