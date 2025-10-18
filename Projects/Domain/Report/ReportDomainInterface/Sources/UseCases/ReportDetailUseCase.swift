//
//  ReportDetailUseCase.swift
//  ReportDomainInterface
//
//  Created by Jiyeon on 10/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct ReportDetailUseCase {
  public var execute: @Sendable (_ userId: Int, _ reportId: Int) async throws -> ReportDetailEntity
  
  public init(
    execute: @Sendable @escaping (
      _ userId: Int,
      _ reportId: Int
    ) async throws -> ReportDetailEntity
  ) {
    self.execute = execute
  }
}
