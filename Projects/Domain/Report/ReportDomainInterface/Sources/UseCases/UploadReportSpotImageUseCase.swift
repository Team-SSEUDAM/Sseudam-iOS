//
//  UploadReportSpotImageUseCase.swift
//  ReportDomainInterface
//
//  Created by 조용인 on 7/7/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Utility

public struct UploadReportSpotImageUseCase {
  public var execute: @Sendable (
    _ spotImage: UIImage,
    _ presignedURL: String
  ) async throws -> Void
  
  public init(
    execute: @Sendable @escaping (
      _ spotImage: UIImage,
      _ presignedURL: String
    ) async throws -> Void
  ) {
    self.execute = execute
  }
}
