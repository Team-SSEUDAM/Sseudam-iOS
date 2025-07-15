//
//  PetUseCase.swift
//
//  PetDomainInterface
//
//  Created by yongin
//

import Foundation

public struct PetUseCase {
  public var execute: @Sendable () async throws -> Void
  
  public init(execute: @Sendable @escaping () async throws -> Void) {
    self.execute = execute
  }
}
