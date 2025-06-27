//
//  SignUpUseCase.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct SignUpUseCase {
  public var execute: @Sendable (
    _ email: String,
    _ nickname: String,
    _ address: String
  ) async throws -> Void
  
  public init(
    execute: @Sendable @escaping (
      _ email: String,
      _ nickname: String,
      _ address: String
    ) async throws -> Void
  ) {
    self.execute = execute
  }
}
