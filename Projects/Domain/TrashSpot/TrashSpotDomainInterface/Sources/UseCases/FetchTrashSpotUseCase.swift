//
//  FetchTrashSpotUseCase.swift
//  TrashSpotDomainInterface
//
//  Created by Jiyeon on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct FetchTrashSpotUseCase {
  public var execute: @Sendable (FetchTrashSpotParameter) async throws -> [TrashSpot]
  
  public init(execute: @Sendable @escaping (FetchTrashSpotParameter) async throws -> [TrashSpot]) {
    self.execute = execute
  }
}
