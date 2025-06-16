//
//  HomeRepository.swift
//
//  HomeDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct HomeRepository {
  public var fetchData: @Sendable () async throws -> String

  public init(fetchData: @Sendable @escaping () async throws -> String) {
    self.fetchData = fetchData
  }
}
