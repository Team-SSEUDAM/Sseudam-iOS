//
//  VisitedUseCase.swift
//
//  VisitedDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct VisitedUseCase {
  public var execute: @Sendable () async throws -> Void
  
  public init(execute: @Sendable @escaping () async throws -> Void) {
    self.execute = execute
  }
}
