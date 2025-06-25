//
//  UserUseCase.swift
//
//  UserDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct UserUseCase {
  public var execute: @Sendable () async throws -> Void
  
  public init(execute: @Sendable @escaping () async throws -> Void) {
    self.execute = execute
  }
}
