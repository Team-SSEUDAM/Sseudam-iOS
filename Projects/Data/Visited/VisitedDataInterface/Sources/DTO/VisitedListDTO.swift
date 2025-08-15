//
//  VisitedListDTO.swift
//  VisitedDataInterface
//
//  Created by 조용인 on 8/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit
import VisitedDomainInterface

public struct VisitedListDTO: DTO {
  public typealias Entity = [VisitedListEntity]
  
  public let list: [VisitedSpot]
  
  public struct VisitedSpot: Decodable, Sendable, Equatable {
    public let id: Int
    public let spotId: Int
    public let userId: String
    public let site: String
    public let visitedAt: String
  }
}

extension VisitedListDTO {
  public func toEntity() -> Entity {
    return list.map {
      VisitedListEntity(
        id: $0.id,
        site: $0.site,
        date: $0.visitedAt
      )
    }
  }
}
