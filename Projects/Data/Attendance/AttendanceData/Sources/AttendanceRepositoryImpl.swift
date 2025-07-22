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
  static var live: AttendanceRepository {
    AttendanceRepository(
      fetchData: {
        // 실제 네트워크 작업 구현
        return
      }
    )
  }
}
