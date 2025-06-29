//
//  NMReverseGeoCodeUseCase.swift
//
//  NMReverseGeocodingDomainInterface
//
//  Created by yongin
//

import Foundation

public struct NMReverseGeoCodeUseCase {
  public var execute: @Sendable (
    _ input: NMReverseGeoCodeInput
  ) async throws -> NMGeoCodeReverseEntity
  
  public init(
    execute: @Sendable @escaping (
      _ input: NMReverseGeoCodeInput
    ) async throws -> NMGeoCodeReverseEntity
  ) {
    self.execute = execute
  }
}
