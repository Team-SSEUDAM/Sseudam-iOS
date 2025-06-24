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
}
