//
//  NetworkError.swift
//  Utility
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public enum NetworkError: Error, LocalizedError, Sendable, Equatable {
  
  case invalidStatusCode(Int)
  case timeout(TimeInterval)
  case serverError(message: String, code: Int)
  case customError(message: String)
  case taskCancelled
  
  public var errorDescription: String {
    switch self {
    case let .serverError(message, code): return "[에러코드: \(code)] - \(message)"
    case let .invalidStatusCode(code): return "[잘못 된 StatusCode] - \(code)"
    case let .timeout(time): return "[네트워크 요청 시간이 초과되었습니다.] - \(time)Seconds"
    case let .customError(message): return "[커스텀 에러] - \(message)"
    case .taskCancelled: return "[네트워크 요청이 취소되었습니다.]"
    }
  }
}
