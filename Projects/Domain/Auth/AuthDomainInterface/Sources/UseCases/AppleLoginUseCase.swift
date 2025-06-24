//
//  AppleLoginUseCase.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct AppleLoginUseCase {
  public var execute: @Sendable (String) async throws -> SocialLoginEntity
  
  public init(execute: @Sendable @escaping (String) async throws -> SocialLoginEntity) {
    self.execute = execute
  }
}
