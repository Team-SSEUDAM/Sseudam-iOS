//
//  FetchPetHistoryInfoUseCase.swift
//  PetDomainInterface
//
//  Created by 조용인 on 7/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct FetchPetHistoryInfoUseCase {
  public var execute: @Sendable () async throws -> PetHistoryInfoEntity
  
  public init(execute: @Sendable @escaping () async throws -> PetHistoryInfoEntity) {
    self.execute = execute
  }
}
