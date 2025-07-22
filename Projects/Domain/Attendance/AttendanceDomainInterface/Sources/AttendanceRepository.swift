//
//  AttendanceRepository.swift
//
//  AttendanceDomainInterface
//
//  Created by Jiyeon
//

import Foundation

public struct AttendanceRepository {
  public var fetchData: @Sendable () async throws -> Void

  public init(fetchData: @Sendable @escaping () async throws -> Void) {
    self.fetchData = fetchData
  }
}
