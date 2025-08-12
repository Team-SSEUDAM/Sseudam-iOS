//
//  GetSuggestionAndHistoryUseCase.swift
//
//  HistoryDomainInterface
//
//  Created by yongin
//

import Foundation

public struct GetSuggestionAndHistoryUseCase {
  public var execute: @Sendable () async throws -> [SuggestionAndReportHistoryEntity]
  
  public init(
    execute: @Sendable @escaping () async throws -> [SuggestionAndReportHistoryEntity]
  ) {
    self.execute = execute
  }
}
