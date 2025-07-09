//
//  SpotNameValidateUseCase.swift
//  SuggestionDomainInterface
//
//  Created by 조용인 on 6/30/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility

public struct SpotNameValidateUseCase {
  public var execute: @Sendable (
    _ spotName: String
  ) async throws -> Bool
  
  public init(
    execute: @Sendable @escaping (
      _ spotName: String
    ) async throws -> Bool
  ) {
    self.execute = execute
  }
}
