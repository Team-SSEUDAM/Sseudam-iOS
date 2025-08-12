//
//  ChangeNicknameUseCase.swift
//  UserDomainInterface
//
//  Created by 조용인 on 8/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct ChangeNicknameUseCase {
  public var execute: @Sendable (String) async throws -> Void
  
  public init(execute: @Sendable @escaping (String) async throws -> Void) {
    self.execute = execute
  }
}
