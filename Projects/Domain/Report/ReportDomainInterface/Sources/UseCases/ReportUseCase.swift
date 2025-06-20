//
//  ReportUseCase.swift
//
//  ReportDomainInterface
//
//  Created by yongin
//

import Foundation

public struct ReportUseCase {
  public var execute: @Sendable () async throws -> Void
  
  public init(execute: @Sendable @escaping () async throws -> Void) {
    self.execute = execute
  }
}
