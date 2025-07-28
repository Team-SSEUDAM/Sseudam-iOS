//
//  AttendanceRepository.swift
//
//  AttendanceDomainInterface
//
//  Created by Jiyeon
//

import Foundation

public struct AttendanceRepository {
  public var checkAttendance: @Sendable (_ userId: Int) async throws -> AttendanceEntity

  public init(
    checkAttendance: @Sendable @escaping (_ userId: Int) async throws -> AttendanceEntity
  ) {
    self.checkAttendance = checkAttendance
  }
}
