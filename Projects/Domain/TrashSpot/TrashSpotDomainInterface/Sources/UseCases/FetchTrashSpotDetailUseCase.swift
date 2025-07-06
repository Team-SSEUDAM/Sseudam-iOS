//
//  FetchTrashSpotDetailUseCase.swift
//  TrashSpotDomainInterface
//
//  Created by Jiyeon on 7/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct FetchTrashSpotDetailUseCase {
  public var execute: @Sendable (_ id: Int) async throws -> TrashSpotDetail
  
  public init(execute: @Sendable @escaping (_ id: Int) async throws -> TrashSpotDetail) {
    self.execute = execute
  }
}
