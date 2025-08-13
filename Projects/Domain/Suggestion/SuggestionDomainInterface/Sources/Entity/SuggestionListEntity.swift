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
  public var id: Int
  public let imageUrl: String
  public let status: ApprovalStatus
  public let address: String
  public let date: String
  
  public init(
    id: Int,
    imageUrl: String,
    status: String,
    address: String,
    date: String
  ) {
    self.id = id
    self.imageUrl = imageUrl
    self.status = ApprovalStatus(rawValue: status) ?? .pending
    self.address = address
    self.date = date.toFormattedDateOptional() ?? date
  }
}

