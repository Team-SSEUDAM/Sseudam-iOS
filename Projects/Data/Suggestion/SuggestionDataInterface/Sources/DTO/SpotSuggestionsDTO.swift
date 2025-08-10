//
//  SpotSuggestionsDTO.swift
//  SuggestionDataInterface
//
//  Created by 조용인 on 8/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit
import SuggestionDomainInterface

public struct SpotSuggestionsDTO: DTO {
  public typealias Entity = [SuggestionListEntity]
  
  public let list: [SpotSuggestion]
  
  public struct SpotSuggestion: Sendable, Codable, Equatable {
    public let id: Int
    public let point: Coordinates
    public let region: String
    public let address: Address
    public let trashType: String
    public let imageUrl: String
    public let status: String
    public let createdAt: String
    
    
    public struct Coordinates: Sendable, Codable, Equatable {
      public let type: String
      public let coordinates: [Double]
    }
    
    public struct Address: Sendable, Codable, Equatable {
      let city: String
      let site: String
    }
  }
}

public extension SpotSuggestionsDTO {
  func toEntity() -> Entity {
    return list.map {
      SuggestionListEntity(
        imageUrl: $0.imageUrl,
        status: $0.status,
        address: $0.address.site,
        date: $0.createdAt
      )
    }
  }
}
