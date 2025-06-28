//
//  NMReverseGeoCodeUseCase.swift
//  ReportDomainInterface
//
//  Created by 조용인 on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
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
