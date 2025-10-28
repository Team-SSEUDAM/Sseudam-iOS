//
//  SuggestionDetailUseCase.swift
//  SuggestionDomainInterface
//
//  Created by Jiyeon on 10/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct SuggestionDetailUseCase {
  public var execute: @Sendable (_ userId: Int, _ suggestionId: Int) async throws -> SuggestionDetailEntity
  
  public init(
    execute: @Sendable @escaping (_ userId: Int, _ suggestionId: Int) async throws -> SuggestionDetailEntity
  ) {
    self.execute = execute
  }
}

