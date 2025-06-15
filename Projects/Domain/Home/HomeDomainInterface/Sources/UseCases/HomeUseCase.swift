//
//  HomeUseCase.swift
//
//  HomeDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct HomeUseCase {
  public var execute: @Sendable () async throws -> String
  
  public init(execute: @Sendable @escaping () async throws -> String) {
    self.execute = execute
  }
}
