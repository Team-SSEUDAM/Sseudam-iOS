//
//  SignUpUseCase.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct SignUpUseCase {
  public var execute: @Sendable (SignUpInput) async throws -> Void
  
  public init(
    execute: @Sendable @escaping (SignUpInput) async throws -> Void
  ) {
    self.execute = execute
  }
}
