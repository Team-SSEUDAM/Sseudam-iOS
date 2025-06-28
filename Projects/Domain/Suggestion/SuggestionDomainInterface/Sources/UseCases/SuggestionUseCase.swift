//
//  SuggestionUseCase.swift
//
//  SuggestionDomainInterface
//
//  Created by yongin
//

import Foundation

public struct SuggestionUseCase {
  public var execute: @Sendable () async throws -> Void
  
  public init(execute: @Sendable @escaping () async throws -> Void) {
    self.execute = execute
  }
}
