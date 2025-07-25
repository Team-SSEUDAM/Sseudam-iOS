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
    .init(
      userId: userId,
      continuity: continuity,
      isContinity: isContinuity
    )
  }
}

/*
 {
   "userId": 1,
   "date": "2025-06-30",
   "continuity": 3,
   "isContinuity": true,
   "createdAt": "2025-06-30T12:00:00"
 }
 */
