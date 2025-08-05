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
  
  
  /// 현재 시간 비교해서 남은 시간을 반환하는 메서드
  /// - Returns: 시간이 남아있으면 TimerInterval 타입을, 시간이 지났다면 nil을 반환
  public func remainingFromNow() -> TimeInterval? {
      let interval = self.timeIntervalSinceNow
      return interval > 0 ? interval : nil
  }
  
  /// 타겟 날짜가 오늘 날짜인지 여부
  public var isSameDayAsToday: Bool {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(secondsFromGMT: 0)! // UTC 기준
    return calendar.isDate(self, inSameDayAs: Date())
    
  }
  
}
