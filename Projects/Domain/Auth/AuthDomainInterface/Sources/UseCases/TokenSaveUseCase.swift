//
//  TokenSaveUseCase.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 6/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct TokenSaveUseCase {
  public var execute: @Sendable (SocialLoginEntity) async -> Void
  
  public init(execute: @Sendable @escaping (SocialLoginEntity) async -> Void) {
    self.execute = execute
  }
}
