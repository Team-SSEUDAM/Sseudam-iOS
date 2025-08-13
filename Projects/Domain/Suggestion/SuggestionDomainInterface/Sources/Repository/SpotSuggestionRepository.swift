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
  
  public var getSpotValidation: @Sendable (
    _ input: SpotNameValidateInput
  ) async throws -> Bool
  
  public var getSuggestionList: @Sendable () async throws -> [SuggestionListEntity]
  
  public init(
    postSpotSuggestion: @Sendable @escaping (
      _ input: SpotSuggestionInput
    ) async throws -> SpotSuggestionEntity,
    putSpotImage: @Sendable @escaping (
      _ input: UploadSpotImageInput
    ) async throws -> Void ,
    getSpotValidation: @Sendable @escaping (
      _ input: SpotNameValidateInput
    ) async throws -> Bool,
    getSuggestionList: @Sendable @escaping () async throws -> [SuggestionListEntity]
  ) {
    self.postSpotSuggestion = postSpotSuggestion
    self.putSpotImage = putSpotImage
    self.getSpotValidation = getSpotValidation
    self.getSuggestionList = getSuggestionList
  }
}
