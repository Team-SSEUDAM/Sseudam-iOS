//
//  SuggestionListEntity.swift
//  SuggestionDomainInterface
//
//  Created by 조용인 on 8/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility

public struct SuggestionListEntity: Sendable, Equatable {
  public let imageUrl: String
  public let status: String
  public let address: String
  public let date: String
  
  public init(
    imageUrl: String,
    status: String,
    address: String,
    date: String
  ) {
    self.imageUrl = imageUrl
    self.status = status
    self.address = address
    self.date = date.toFormattedDateOptional() ?? date
  }
}

