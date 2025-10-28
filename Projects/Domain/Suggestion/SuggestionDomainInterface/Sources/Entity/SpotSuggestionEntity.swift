//
//  SpotSuggestionEntity.swift
//
//  SuggestionDomainInterface
//
//  Created by yongin
//

import Foundation

public struct SpotSuggestionEntity: Sendable, Equatable {
  public let imageUploadURL: String?
  public let suggestionID: Int
  
  public init(
    imageUploadURL: String?,
    suggestionID: Int
  ) {
    self.imageUploadURL = imageUploadURL
    self.suggestionID = suggestionID
  }
}

