//
//  TokenDeleteUseCase.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 7/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct TokenDeleteUseCase {
  public var execute: @Sendable () async -> Void
  
  public init(execute: @Sendable @escaping () async -> Void) {
    self.execute = execute
  }
}

