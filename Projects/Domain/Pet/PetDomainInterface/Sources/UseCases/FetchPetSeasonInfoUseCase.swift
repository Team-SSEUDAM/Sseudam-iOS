//
//  FetchPetSeasonInfoUseCase.swift
//  PetDomainInterface
//
//  Created by 조용인 on 7/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct FetchPetSeasonInfoUseCase {
  public var execute: @Sendable () async throws -> PetSeasonInfoEntity
  
  public init(execute: @Sendable @escaping () async throws -> PetSeasonInfoEntity) {
    self.execute = execute
  }
}
