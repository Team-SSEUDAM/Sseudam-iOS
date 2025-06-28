//
//  SuggestionUseCaseImpl.swift
//
//  SuggestionDomain
//
//  Created by yongin
//

import Foundation
import SuggestionDomainInterface

extension SuggestionUseCase {
  public static func live(repository: SuggestionRepository) -> SuggestionUseCase {
    .init {
      try await repository.fetchData()
    }
  }
}
