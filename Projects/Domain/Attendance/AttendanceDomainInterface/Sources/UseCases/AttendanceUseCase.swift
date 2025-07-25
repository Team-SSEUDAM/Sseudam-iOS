//
//  AttendanceUseCase.swift
//
//  AttendanceDomainInterface
//
//  Created by Jiyeon
//

import Foundation

public struct AttendanceUseCase {
  public var execute: @Sendable (_ userId: Int) async throws -> AttendanceEntity
  
  public init(execute: @Sendable @escaping (_ userId: Int) async throws -> AttendanceEntity) {
    self.execute = execute
  }
}
