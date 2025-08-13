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
  public let status: ApprovalStatus
  public let address: String
  public let date: String
  public let actionType: ActionType
  
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
    self.status = ApprovalStatus(rawValue: status) ?? .pending
    self.address = address
    self.actionType = ActionType(rawValue: actionType) ?? .unknown
    self.date = date.toFormattedDateOptional() ?? date
  }
}

public enum ActionType: String, Sendable {
  case suggestion = "SUGGESTION"
  case report = "REPORT"
  case unknown = "UNKNOWN"
}
