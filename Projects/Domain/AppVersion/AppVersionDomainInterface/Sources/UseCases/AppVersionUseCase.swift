//
//  AppVersionUseCase.swift
//
//  AppVersionDomainInterface
//
//  Created by yongin
//

import Foundation

public struct AppVersionUseCase {
  public var execute: @Sendable () async throws -> Void
  
  public init(execute: @Sendable @escaping () async throws -> Void) {
    self.execute = execute
  }
}
