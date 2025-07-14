//
//  FetchUserInfoUseCase.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 7/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct FetchUserInfoUseCase {
  public var execute: @Sendable () async throws -> UserInfoEntity
  
  public init(execute: @Sendable @escaping () async throws -> UserInfoEntity) {
    self.execute = execute
  }
}
