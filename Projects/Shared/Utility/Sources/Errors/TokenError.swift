//
//  TokenError.swift
//  Utility
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public enum TokenError: LocalizedError, Sendable {
  case expiredToken
  case invalidToken
  
  public var errorDescription: String {
    switch self {
    case .expiredToken:
      return "[Token이 만료되었습니다.]"
    case .invalidToken:
      return "[유효한 Token이 아닙니다.]"
    }
  }
}
