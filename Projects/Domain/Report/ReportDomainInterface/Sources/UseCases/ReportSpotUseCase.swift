//
//  ReportSpotUseCase.swift
//
//  ReportDomainInterface
//
//  Created by yongin
//

import Foundation
import Utility
import NMReverseGeocodingDomainInterface

public struct ReportSpotUseCase {
  public var execute: @Sendable (
    _ spotId: Int,
    _ spotName: String,
    _ centerPoint: Coordinates?,
    _ nmReverseGeoCode: NMGeoCodeReverseEntity?,
    _ trashType: String
  ) async throws -> String
  
  public init(
    execute: @Sendable @escaping (
      _ spotId: Int,
      _ spotName: String,
      _ centerPoint: Coordinates?,
      _ nmReverseGeoCode: NMGeoCodeReverseEntity?,
      _ trashType: String
    ) async throws -> String
  ) {
    self.execute = execute
  }
}
