//
//  ApprovalStatus.swift
//  Utility
//
//  Created by 조용인 on 8/13/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

/// 제보 / 신고의 승인 상태를 나타내는 열거형입니다.
public enum ApprovalStatus: String, Sendable {
  case approved = "APPROVE"
  case rejected = "REJECT"
  case pending = "WAITING"
  
  public var ko: String {
    switch self {
    case .approved: return "승인 완료"
    case .rejected: return "승인 거절"
    case .pending: return "승인 대기중"
    }
  }
}
