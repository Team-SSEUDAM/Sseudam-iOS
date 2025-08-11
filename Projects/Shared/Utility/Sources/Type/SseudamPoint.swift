//
//  SseudamPoint.swift
//  Utility
//
//  Created by Jiyeon on 8/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public enum SseudamPoint {
  case continutityAttendance
  case attendance
  
}

extension SseudamPoint {
  public var point: Int {
    switch self {
    case .continutityAttendance:
      return 5
    case .attendance:
      return 2
    }
  }
  
  public var sseudamText: String {
    return "\(self.point.description)쓰담"
  }
  
}
