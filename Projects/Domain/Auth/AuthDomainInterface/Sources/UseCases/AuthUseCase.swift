//
//  AuthUseCase.swift
//
//  AuthDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct AuthUseCase {
  public var execute: @Sendable () async throws -> Void
  
  public init(execute: @Sendable @escaping () async throws -> Void) {
    self.execute = execute
  }
}
