//
//  GetSuggestionListUseCaseImpl.swift
//  SuggestionDomain
//
//  Created by 조용인 on 8/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import SuggestionDomainInterface

extension GetSuggestionListUseCase {
  public static func live(repository: SpotSuggestionRepository) -> GetSuggestionListUseCase {
    .init {
      return try await repository.getSuggestionList()
    }
  }
}
