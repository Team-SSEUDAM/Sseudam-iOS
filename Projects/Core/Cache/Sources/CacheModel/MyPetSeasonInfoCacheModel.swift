//
//  MyPetSeasonInfoCacheModel.swift
//  Cache
//
//  Created by 조용인 on 7/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct MyPetSeasonInfoCacheModel: Sendable, Equatable, Codable {
  public let seasonPetInfo: [PetGrowthCacheModel]
  
  public init(
    _ seasonPetInfo: [PetGrowthCacheModel]
  ) {
    self.seasonPetInfo = seasonPetInfo
  }
}

public struct PetGrowthCacheModel: Sendable, Equatable, Codable {
  public let nickname: String
  public let needPoint: Int
  public let levelType: String
  public let isLocked: Bool
  public let season: String
  public let createdAt: String
  
  public init(
    nickname: String,
    needPoint: Int,
    levelType: String,
    isLocked: Bool,
    season: String,
    createdAt: String
  ) {
    self.nickname = nickname
    self.needPoint = needPoint
    self.levelType = levelType
    self.isLocked = isLocked
    self.season = season
    self.createdAt = createdAt
  }
}
