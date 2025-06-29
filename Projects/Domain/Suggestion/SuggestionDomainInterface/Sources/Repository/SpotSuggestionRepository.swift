//
//  SpotSuggestionRepository.swift
//
//  SuggestionDomainInterface
//
//  Created by yongin
//

import Foundation

public struct SpotSuggestionRepository {
  public var postSpotSuggestion: @Sendable (
    _ input: SpotSuggestionInput
  ) async throws -> SpotSuggestionEntity
  
  public init(
    postSpotSuggestion: @Sendable @escaping (
      _ input: SpotSuggestionInput
    ) async throws -> SpotSuggestionEntity
  ) {
    self.postSpotSuggestion = postSpotSuggestion
  }
}
