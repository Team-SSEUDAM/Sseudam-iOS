//
//  ChangePetNicknameUseCase.swift
//  PetDomainInterface
//
//  Created by 조용인 on 7/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct ChangePetNicknameUseCase {
  public var execute: @Sendable (String) async throws -> Void
  
  public init(
    execute: @Sendable @escaping (String) async throws -> Void
  ) {
    self.execute = execute
  }
}
