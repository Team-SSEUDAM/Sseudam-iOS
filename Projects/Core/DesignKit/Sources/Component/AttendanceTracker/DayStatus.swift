//
//  DayStatus.swift
//  DesignKit
//
//  Created by Jiyeon on 7/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
public enum DayStatus {
  case empty
  case success
  case fail
}

public extension DayStatus {
  var icon: ImageSet {
    switch self {
    case .empty:
      return .attendanceEmpty
    case .success:
      return .attendanceSuccess
    case .fail:
      return .attendanceFail
    }
  }
}
