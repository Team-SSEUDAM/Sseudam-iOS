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
  public let isContinity: Bool
  
  public init(userId: Int, continuity: Int, isContinity: Bool) {
    self.userId = userId
    self.continuity = continuity
    self.isContinity = isContinity
  }
}
