//
//  CheckRecentVisitUseCase.swift
//  VisitedDomainInterface
//
//  Created by Jiyeon on 7/19/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct CheckRecentVisitUseCase {
  public var execute: @Sendable (_ userId: Int, _ spotId: Int) async throws -> CheckRecentVisitEntity
  
  public init(execute: @Sendable @escaping (_ userId: Int, _ spotId: Int) async throws -> CheckRecentVisitEntity) {
    self.execute = execute
  }
}
