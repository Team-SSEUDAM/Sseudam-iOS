//
//  PetRepository.swift
//
//  PetDomainInterface
//
//  Created by yongin
//

import Foundation

public struct PetRepository {
  
  public var getPetInfo: @Sendable () async throws -> PetInfoEntity

  public init(
    getPetInfo: @Sendable @escaping () async throws -> PetInfoEntity
  ) {
    self.getPetInfo = getPetInfo
  }
}
