//
//  HistoryRepository.swift
//
//  HistoryDomainInterface
//
//  Created by yongin
//

import Foundation

public struct HistoryRepository {
  public var getSuggestionAndHistory: @Sendable () async throws -> [SuggestionAndReportHistoryEntity]

  public init(
    getSuggestionAndHistory: @Sendable @escaping () async throws -> [SuggestionAndReportHistoryEntity]
  ) {
    self.getSuggestionAndHistory = getSuggestionAndHistory
  }
}
