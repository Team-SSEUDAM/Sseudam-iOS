//
//  SuggestionUseCase.swift
//
//  SuggestionDomainInterface
//
//  Created by yongin
//

import Foundation
import Utility
import NMReverseGeocodingDomainInterface

public struct SpotSuggestionUseCase {
  public var execute: @Sendable (
    _ spotName: String,
    _ centerPoint: Coordinates?,
    _ nmReverseGeoCode: NMGeoCodeReverseEntity?,
    _ trashType: String
  ) async throws -> SpotSuggestionEntity
  
  public init(
    execute: @Sendable @escaping (
      _ spotName: String,
      _ centerPoint: Coordinates?,
      _ nmReverseGeoCode: NMGeoCodeReverseEntity?,
      _ trashType: String
    ) async throws -> SpotSuggestionEntity
  ) {
    self.execute = execute
  }
}
