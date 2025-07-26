//
//  AttendanceEntity.swift
//
//  AttendanceDomainInterface
//
//  Created by Jiyeon
//

import Foundation

public struct AttendanceEntity: Sendable, Equatable {
  public let userId: Int
  public let continuity: Int
  public let isContinuity: Bool
  public let status: AttendanceStatus
  
  public init(userId: Int, continuity: Int, isContinuity: Bool) {
    self.userId = userId
    self.continuity = continuity

    let status: AttendanceStatus
    switch continuity {
    case 1:
      self.isContinuity = true
      status = .first
    case 5:
      self.isContinuity = isContinuity
      status = .continuedSuccess
    default:
      self.isContinuity = isContinuity
      status = isContinuity ? .success(day: continuity) : .fail
    }

    self.status = status
  }
}
