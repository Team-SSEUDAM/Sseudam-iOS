//
//  SpotSuggestionEntity.swift
//
//  SuggestionDomainInterface
//
//  Created by yongin
//

import Foundation

public struct SpotSuggestionEntity: Sendable, Equatable {
  public let imageUploadURL: String
  
  public init(imageUploadURL: String) {
    self.imageUploadURL = imageUploadURL
  }
}

