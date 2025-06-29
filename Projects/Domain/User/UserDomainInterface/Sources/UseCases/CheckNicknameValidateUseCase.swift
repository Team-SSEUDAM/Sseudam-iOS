//
//  CheckNicknameValidateUseCase.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 6/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct CheckNicknameValidateUseCase {
  public var execute: @Sendable (String) async throws -> NicknameValidEntity
  
  public init(execute: @Sendable @escaping (String) async throws -> NicknameValidEntity) {
    self.execute = execute
  }
}
