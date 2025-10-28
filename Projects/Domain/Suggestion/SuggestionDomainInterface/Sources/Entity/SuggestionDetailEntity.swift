//
//  SuggestionDetailEntity.swift
//  SuggestionDomainInterface
//
//  Created by Jiyeon on 10/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility

public struct SuggestionDetailEntity: Sendable, Equatable, Identifiable {
  public let id: Int
  public let point: Coordinates
  public let address: String
  public let rejectReason: String
  
  public init(id: Int, point: Coordinates, address: String, rejectReason: String) {
    self.id = id
    self.point = point
    self.address = address
    self.rejectReason = rejectReason
  }
}
