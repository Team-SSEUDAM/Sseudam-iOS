//
//  ReportSpotUseCase.swift
//
//  ReportDomainInterface
//
//  Created by yongin
//

import Foundation
import Utility
import TrashSpotDomainInterface

public struct ReportSpotUseCase {
  public var execute: @Sendable (
    _ reportType: String,
    _ trashSpotDetail: TrashSpotFlattenDetailEntity?
  ) async throws -> String?
  
  public init(
    execute: @Sendable @escaping (
      _ reportType: String,
      _ trashSpotDetail: TrashSpotFlattenDetailEntity?
    ) async throws -> String?
  ) {
    self.execute = execute
  }
}
