//
//  AuthRepository.swift
//
//  AuthDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct AuthRepository {
  public var fetchData: @Sendable () async throws -> Void

  public init(fetchData: @Sendable @escaping () async throws -> Void) {
    self.fetchData = fetchData
  }
}
