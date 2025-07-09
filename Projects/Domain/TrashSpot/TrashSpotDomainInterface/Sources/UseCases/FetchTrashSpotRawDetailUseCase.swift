//
//  FetchTrashSpotRawDetailUseCase.swift
//  TrashSpotDomainInterface
//
//  Created by 조용인 on 7/8/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct FetchTrashSpotRawDetailUseCase {
  public var execute: @Sendable (_ id: Int) async throws -> TrashSpotFlattenDetailEntity
  
  public init(execute: @Sendable @escaping (_ id: Int) async throws -> TrashSpotFlattenDetailEntity) {
    self.execute = execute
  }
}
