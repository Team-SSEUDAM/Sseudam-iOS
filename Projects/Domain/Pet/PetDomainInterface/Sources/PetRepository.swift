//
//  PetRepository.swift
//
//  PetDomainInterface
//
//  Created by yongin
//

import Foundation

public struct PetRepository {
  public var fetchData: @Sendable () async throws -> Void

  public init(fetchData: @Sendable @escaping () async throws -> Void) {
    self.fetchData = fetchData
  }
}
