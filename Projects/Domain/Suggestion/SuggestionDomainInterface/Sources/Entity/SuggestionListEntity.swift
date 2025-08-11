//
//  SuggestionListEntity.swift
//  SuggestionDomainInterface
//
//  Created by 조용인 on 8/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility

public struct SuggestionListEntity: Sendable, Equatable, Identifiable {
  public var id: String { self.imageUrl }
  public let imageUrl: String
  public let status: State
  public let address: String
  public let date: String
  
  public enum State: String, Sendable {
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
  
  public init(
    imageUrl: String,
    status: String,
    address: String,
    date: String
  ) {
    self.imageUrl = imageUrl
    self.status = State(rawValue: status) ?? .pending
    self.address = address
    self.date = date.toFormattedDateOptional() ?? date
  }
}

