//
//  UploadSpotImageUseCase.swift
//  SuggestionDomainInterface
//
//  Created by 조용인 on 6/29/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Utility

public struct UploadSpotImageUseCase {
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
