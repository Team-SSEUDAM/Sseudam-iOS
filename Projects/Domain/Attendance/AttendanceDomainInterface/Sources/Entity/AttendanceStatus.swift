//
//  AttendanceStatus.swift
//  AttendanceDomainInterface
//
//  Created by Jiyeon on 7/27/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public enum AttendanceStatus: Sendable, Equatable {
  case first
  case success(day: Int)
  case fail
  case continuedSuccess
}
