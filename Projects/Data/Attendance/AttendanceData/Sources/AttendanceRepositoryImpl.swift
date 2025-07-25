//
//  AttendanceRepositoryImpl.swift
//
//  Attendance
//
//  Created by Jiyeon
//

import Foundation
import AttendanceDomainInterface
import AttendanceDataInterface
import NetworkKit

public extension AttendanceRepository {
  static func live(networker: NetworkKit) -> AttendanceRepository {
    AttendanceRepository(
      checkAttendance: { userId in
        let parameter = AttendanceBody(user: userId)
        let endpoint = AttendanceEndPoint.checkAttendance(parameter: parameter)
        return try await networker.execute(with: endpoint, timeout: 30).toEntity()
      }
    )
  }
}
