//
//  PetHistoryInfoDTO.swift
//  PetDataInterface
//
//  Created by 조용인 on 7/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import PetDomainInterface
import NetworkKit

public struct PetHistoryInfoDTO: DTO {
  public typealias Entity = PetHistoryInfoEntity
  
  public let list: [List]
  
  public struct List: Codable, Sendable {
    public let userId: Int
    public let nickname: String
    public let point: Int
    public let levelType: String
    public let season: String
    public let createdAt: String
  }
}

public extension PetHistoryInfoDTO {
  func toEntity() -> Entity {
    let historyEntities = list.map { item -> PetHistoryEachInfo in
      return .init(
        nickname: item.nickname,
        point: item.point,
        levelType: item.levelType,
        season: item.season
      )
    }
    return PetHistoryInfoEntity(petHistory: historyEntities)
  }
}
