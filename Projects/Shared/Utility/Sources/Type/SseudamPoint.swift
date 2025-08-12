//
//  SseudamPoint.swift
//  Utility
//
//  Created by Jiyeon on 8/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public enum SseudamPoint {
  case continuityAttendance
  case attendance
  case firstVisit
  case visit
}

extension SseudamPoint {
  public var point: Int {
    switch self {
    case .firstVisit:
      return 7
    case .continuityAttendance, .visit:
      return 5
    case .attendance:
      return 2
    }
  }
  
  public var sseudamText: String {
    return "\(self.point.description)쓰담"
  }
  
}
