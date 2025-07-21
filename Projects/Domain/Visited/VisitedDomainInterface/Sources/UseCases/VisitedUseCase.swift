//
//  VisitedUseCase.swift
//
//  VisitedDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct VisitedUseCase {
  public var execute: @Sendable (_ userId: Int, _ spotId: Int) async throws -> VisitedCompleteEntity
  
  public init(execute: @Sendable @escaping (_ userId: Int, _ spotId: Int) async throws -> VisitedCompleteEntity) {
    self.execute = execute
  }
}
