//
//  SuggestionDetailUseCaseImpl.swift
//  SuggestionDomain
//
//  Created by Jiyeon on 10/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import SuggestionDomainInterface

extension SuggestionDetailUseCase {
  public static func live(repository: SpotSuggestionRepository) -> SuggestionDetailUseCase {
    .init { userId, suggestionId in
      let input = SuggestionDetailInput(userId: userId, suggestionId: suggestionId)
      return try await repository.getSuggestionDetail(input)
    }
  }
}
