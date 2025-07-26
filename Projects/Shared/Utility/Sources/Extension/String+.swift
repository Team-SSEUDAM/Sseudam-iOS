//
//  String+.swift
//  Utility
//
//  Created by Jiyeon on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

extension String {
  var containsEmoji: Bool {
    return self.unicodeScalars.contains { $0.properties.isEmoji }
  }

  public var isValidNicknameStrict: Bool {
    let regex = "^[a-zA-Z0-9가-힣]{2,12}$"
    let isBasicValid = self.range(of: regex, options: .regularExpression) != nil
    return isBasicValid && !containsEmoji
  }
  
  /// ISO 8601 날짜 문자열을 YY-MM-DD 형식으로 변환
  /// - Returns: 변환된 날짜 문자열 또는 변환 실패 시 원본 문자열
  public func toFormattedDate(_ format: String = "yy-MM-dd") -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = format
    
    guard let date = inputFormatter.date(from: self) else {
      // 변환 실패 시 원본 문자열 반환
      return self
    }
    
    return outputFormatter.string(from: date)
  }
  
  public func toFormattedDateOptional(_ format: String = "yy-MM-dd") -> String? {
    return self.toFormattedDate(format) == self ? nil : self.toFormattedDate(format)
  }
  
  public var toDateFromISO8601: Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter.date(from: self)
  }
  
  /// 닉네임을 마지막 띄어쓰기를 기준으로 두 줄로 분리
  ///
  /// - Returns: (첫째줄, 둘째줄) 튜플. 띄어쓰기가 없으면 (전체, nil) 반환
  public func splitNicknameForTwoLines() -> (first: String, second: String?) {
    let words = self.split(separator: " ").map{ String($0) }
    guard words.count > 1 else {
      return (words.first!, nil)
    }
    
    let lastWord = words.last!
    let firstPart = words.dropLast().joined(separator: " ")
    return (firstPart, lastWord)
  }
}
