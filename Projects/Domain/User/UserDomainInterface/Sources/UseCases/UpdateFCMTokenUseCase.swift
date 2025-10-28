//
//  UpdateFCMTokenUseCase.swift
//  UserDomainInterface
//
//  Created by 조용인 on 10/8/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct UpdateFCMTokenUseCase: Sendable {
  public let execute: @Sendable (String) async throws -> Void
  
  public init(
    execute: @escaping @Sendable (String) async throws -> Void
  ) {
    self.execute = execute
  }
}
