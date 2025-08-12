//
//  HistoryEntity.swift
//
//  SuggestionAndReportHistoryEntity
//
//  Created by yongin
//

import Foundation
import Utility

public struct SuggestionAndReportHistoryEntity: Sendable, Equatable, Identifiable {
  public var id: Int
  public let imageUrl: String
  public let status: State
  public let address: String
  public let date: String
  public let actionType: ActionType
  
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
  
  public enum ActionType: String, Sendable {
    case suggestion = "SUGGESTION"
    case report = "REPORT"
    case unknown = "UNKNOWN"
  }

  
  public init(
    id: Int,
    imageUrl: String,
    status: String,
    address: String,
    actionType: String,
    date: String
  ) {
    self.id = id
    self.imageUrl = imageUrl
    self.status = State(rawValue: status) ?? .pending
    self.address = address
    self.actionType = ActionType(rawValue: actionType) ?? .unknown
    self.date = date.toFormattedDateOptional() ?? date
  }
}

