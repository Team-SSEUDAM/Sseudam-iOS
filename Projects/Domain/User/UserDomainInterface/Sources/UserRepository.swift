//
//  UserRepository.swift
//
//  UserDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct UserRepository {
  public var fetchData: @Sendable () async throws -> Void

  public init(fetchData: @Sendable @escaping () async throws -> Void) {
    self.fetchData = fetchData
  }
}
