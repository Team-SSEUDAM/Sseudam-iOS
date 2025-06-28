//
//  SuggestionRepository.swift
//
//  SuggestionDomainInterface
//
//  Created by yongin
//

import Foundation

public struct SuggestionRepository {
  public var fetchData: @Sendable () async throws -> Void

  public init(fetchData: @Sendable @escaping () async throws -> Void) {
    self.fetchData = fetchData
  }
}
