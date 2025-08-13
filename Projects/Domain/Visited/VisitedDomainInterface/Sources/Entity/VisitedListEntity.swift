//
//  VisitedListEntity.swift
//  VisitedDomainInterface
//
//  Created by 조용인 on 8/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility

public struct VisitedListEntity: Equatable, Identifiable {
  public let id: Int
  public let site: String
  public let date: String
  
  public init(
    id: Int,
    site: String,
    date: String
  ) {
    self.id = id
    self.site = site
    self.date = date.toFormattedDate()
  }
}
