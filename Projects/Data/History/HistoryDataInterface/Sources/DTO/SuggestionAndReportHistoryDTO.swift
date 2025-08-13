//
//  HistoryDto.swift
//
//  History
//
//  Created by yongin
//

import Foundation
import NetworkKit
import HistoryDomainInterface

public struct SuggestionAndReportHistoryDTO: DTO {
  public typealias Entity = [SuggestionAndReportHistoryEntity]
  
  public let list: [SpotSuggestion]
  
  public struct SpotSuggestion: Sendable, Codable, Equatable {
    public let id: Int
    public let spotId: Int?
    public let userId: Int
    public let point: Coordinates
    public let spotName: String
    public let address: Address
    public let trashType: String
    public let imageUrl: String
    public let status: String
    public let actionType: String
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

public extension SuggestionAndReportHistoryDTO {
  func toEntity() -> Entity {
    return list.map {
      SuggestionAndReportHistoryEntity(
        id: $0.id,
        imageUrl: $0.imageUrl,
        status: $0.status,
        address: $0.address.site,
        actionType: $0.actionType,
        date: $0.createdAt
      )
    }
  }
}

