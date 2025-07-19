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
  public var checkRecentVisit: @Sendable (_ userId: Int, _ spotId: Int) async throws -> CheckRecentVisitEntity

  public init(
    requestVisited: @Sendable @escaping (_ userId: Int, _ spotId: Int) async throws -> VisitedCompleteEntity,
    checkRecentVisit: @Sendable @escaping (_ userId: Int, _ spotId: Int) async throws -> CheckRecentVisitEntity
  ) {
    self.requestVisited = requestVisited
    self.checkRecentVisit = checkRecentVisit
  }
}
