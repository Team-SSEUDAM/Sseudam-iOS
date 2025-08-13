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
    public let userId: Int
    public let spotName: String
    public let point: Point
    public let region: String
    public let address: Address
    public let trashType: String
    public let imageUrl: String
    public let status: String
    public let createdAt: String
    
    public struct Point: Codable, Sendable, Equatable {
      public let type: String
      public let coordinates: [Double]
    }
    
    public struct Address: Codable, Sendable, Equatable {
      public let city: String
      public let site: String
    }
  }
}

extension VisitedListDTO {
  public func toEntity() -> Entity {
    return list.map {
      VisitedListEntity(
        id: $0.id,
        site: $0.address.site,
        date: $0.createdAt
      )
    }
  }
}
