//
//  CheckAppVersionUseCase.swift
//
//  AppVersionDomainInterface
//
//  Created by yongin
//

import Foundation

public struct CheckAppVersionUseCase {
  public var execute: @Sendable () async throws -> AppVersionEntity
  
  public init(
    execute: @Sendable @escaping () async throws -> AppVersionEntity
  ) {
    self.execute = execute
  }
}
