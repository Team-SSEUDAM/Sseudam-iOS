//
//  HistoryUseCaseImpl.swift
//
//  HistoryDomain
//
//  Created by yongin
//

import Foundation
import HistoryDomainInterface

extension GetSuggestionAndHistoryUseCase {
  public static func live(repository: HistoryRepository) -> GetSuggestionAndHistoryUseCase {
    .init {
      try await repository.getSuggestionAndHistory()
    }
  }
}
