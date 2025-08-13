//
//  getVisitedListUseCase.swift
//  VisitedDomainInterface
//
//  Created by 조용인 on 8/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct GetVisitedListUseCase {
  public var execute: @Sendable () async throws -> [VisitedListEntity]
  
  public init(execute: @Sendable @escaping () async throws -> [VisitedListEntity]) {
    self.execute = execute
  }
}
