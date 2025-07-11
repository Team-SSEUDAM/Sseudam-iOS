//
//  Date+.swift
//  Utility
//
//  Created by Jiyeon on 7/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

extension Date {
  /// ISO8601 형식 문자열로 변환
  func toISOString() -> String {
    ISO8601DateFormatter().string(from: self)
  }
  
  /// ISO8601 문자열을 Date로 변환
  static func fromISOString(_ string: String) -> Date? {
    ISO8601DateFormatter().date(from: string)
  }
}
