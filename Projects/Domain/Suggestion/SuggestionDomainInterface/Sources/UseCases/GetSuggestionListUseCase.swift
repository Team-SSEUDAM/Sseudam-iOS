//
//  GetSuggestionListUseCase.swift
//  SuggestionDomainInterface
//
//  Created by 조용인 on 8/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility

public struct GetSuggestionListUseCase {
  public var execute: @Sendable () async throws -> [SuggestionListEntity]
  
  public init(
    execute: @Sendable @escaping () async throws -> [SuggestionListEntity]
  ) {
    self.execute = execute
  }
}
