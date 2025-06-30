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
  
  public var putSpotImage: @Sendable (
    _ input: UploadSpotImageInput
  ) async throws -> Void
  
  public init(
    postSpotSuggestion: @Sendable @escaping (
      _ input: SpotSuggestionInput
    ) async throws -> SpotSuggestionEntity,
    putSpotImage: @Sendable @escaping (
      _ input: UploadSpotImageInput
    ) async throws -> Void
  ) {
    self.postSpotSuggestion = postSpotSuggestion
    self.putSpotImage = putSpotImage
  }
}
