//
//  AttendanceUseCaseImpl.swift
//
//  AttendanceDomain
//
//  Created by Jiyeon
//

import Foundation
import AttendanceDomainInterface

extension AttendanceUseCase {
  public static func live(repository: AttendanceRepository) -> AttendanceUseCase {
    .init { userId in
      try await repository.checkAttendance(userId)
    }
  }
}
