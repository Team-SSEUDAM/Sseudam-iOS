//
//  PetSeasonInfoDTO.swift
//  PetDataInterface
//
//  Created by 조용인 on 7/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import PetDomainInterface
import NetworkKit

public struct PetSeasonInfoDTO: DTO {
  public typealias Entity = PetSeasonInfoEntity
  
  public let userPetInfo: PetInfoDTO
  public let list: [List]
  
  public struct List: Codable, Sendable {
    public let userID: Int
    public let nickname: String
    public let point: Int
    public let levelType: String
    public let isLocked: Bool
    public let season: String
    public let createdAt: String
  }
}

public extension PetSeasonInfoDTO {
  func toEntity() -> Entity {
    let growthEntity = list.map { item -> PetGrowthEntity in
      return .init(
        nickname: item.nickname,
        needPoint: item.point,
        levelType: item.levelType,
        isLocked: item.isLocked,
        season: item.season
      )
    }
    return PetSeasonInfoEntity(growthEntity)
  }
}
