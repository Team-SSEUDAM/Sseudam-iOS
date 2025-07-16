//
//  CheckPetInfoUseCase.swift
//
//  PetDomainInterface
//
//  Created by yongin
//

import Foundation

public struct CheckPetInfoUseCase {
  public var execute: @Sendable () async throws -> PetInfoEntity
  
  public init(execute: @Sendable @escaping () async throws -> PetInfoEntity) {
    self.execute = execute
  }
}
