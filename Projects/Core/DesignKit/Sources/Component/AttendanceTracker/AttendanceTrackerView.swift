//
//  AttendanceTrackerView.swift
//  DesignKit
//
//  Created by Jiyeon on 7/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct AttendanceTrackerView: View {
  
  private let continuityCount: Int
  private let isContinuing: Bool
  
  public init(
    continuityCount: Int = 1,
    isContinuing: Bool = true
  ) {
    self.continuityCount = continuityCount
    self.isContinuing = isContinuing
  }
  
  private var statuses: [DayStatus] {
    var result: [DayStatus] = []
    
    for i in 0..<5 {
      if i < continuityCount {
        result.append(.success)
      } else if i == continuityCount, !isContinuing {
        result.append(.fail)
      } else {
        result.append(.empty)
      }
    }
    
    return result
  }
  
  public var body: some View {
    HStack(spacing: .Number4) {
      ForEach(Array(statuses.enumerated()), id: \.offset) { index, status in
        DayStatusIcon(day: "DAY \(index + 1)", status: status)
      }
    }
  }
}
