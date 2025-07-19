//
//  AttendanceUseCase.swift
//
//  AttendanceDomainInterface
//
//  Created by Jiyeon
//

import Foundation

public struct AttendanceUseCase {
  public var execute: @Sendable () async throws -> Void
  
  public init(execute: @Sendable @escaping () async throws -> Void) {
    self.execute = execute
  }
}
