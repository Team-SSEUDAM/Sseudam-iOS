//
//  VisitedRepository.swift
//
//  VisitedDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct VisitedRepository {
  public var requestVisited: @Sendable (_ userId: Int, _ spotId: Int) async throws -> VisitedCompleteEntity

  public init(requestVisited: @Sendable @escaping (_ userId: Int, _ spotId: Int) async throws -> VisitedCompleteEntity) {
    self.requestVisited = requestVisited
  }
}
