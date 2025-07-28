//
//  AttendanceDto.swift
//
//  Attendance
//
//  Created by Jiyeon
//

import Foundation
import AttendanceDomainInterface
import NetworkKit

public struct AttendanceDTO: DTO {
  let userId: Int
  let date: String
  let continuity: Int
  let isContinuity: Bool
  let createdAt: String
  
  public func toEntity() throws -> AttendanceEntity {
    return  .init(
      userId: userId,
      continuity: continuity,
      isContinuity: isContinuity,
      attendanceDate: createdAt.toUTCDate
    )
  }
}
