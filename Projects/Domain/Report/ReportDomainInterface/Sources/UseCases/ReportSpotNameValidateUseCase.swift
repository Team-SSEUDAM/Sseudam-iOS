//
//  ReportSpotNameValidateUseCase.swift
//  ReportDomainInterface
//
//  Created by 조용인 on 7/7/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility

public struct ReportSpotNameValidateUseCase {
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
