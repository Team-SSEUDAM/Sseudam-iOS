//
//  PetSeasonInfoEntity.swift
//  PetDomainInterface
//
//  Created by 조용인 on 7/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import DesignKit
import Cache

public struct PetSeasonInfoEntity: Sendable, Equatable {
  public let seasonPetInfo: [PetGrowthEntity]
  
  public init(
    _ seasonPetInfo: [PetGrowthEntity]
  ) {
    self.seasonPetInfo = seasonPetInfo
  }
  
  public init(
    _ cacheModel: MyPetSeasonInfoCacheModel
  ) {
    self.seasonPetInfo = cacheModel.seasonPetInfo.map { PetGrowthEntity($0) }
  }
  
  public func makeCacheModel() -> MyPetSeasonInfoCacheModel {
    return MyPetSeasonInfoCacheModel(
      seasonPetInfo.map { $0.makeCacheModel($0) }
    )
  }
}

public struct PetGrowthEntity: Sendable, Equatable {
  public let nickname: String /// 해당 시즌의 고양이 이름 (관형사 포함)
  public let needPoint: Int /// 해당 레벨에 도달하기 위해 필요한 포인트
  public let levelType: CatLevel /// 해당 레벨의 타입
  public let isLocked: Bool /// 해당 레벨이 잠겨있는지 여부
  public let season: CatType /// 현재 시즌 이름 (ex. `basic`)
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
    self.levelType = CatLevel(rawValue: levelType) ?? .level1
    self.isLocked = isLocked
    self.season = CatType(rawValue: season) ?? ._2025_07
    self.createdAt = createdAt
  }
  
  public init(
    _ cacheModel: PetGrowthCacheModel
  ) {
    self.init(
      nickname: cacheModel.nickname,
      needPoint: cacheModel.needPoint,
      levelType: cacheModel.levelType,
      isLocked: cacheModel.isLocked,
      season: cacheModel.season,
      createdAt: cacheModel.createdAt
    )
  }
  
  fileprivate func makeCacheModel(_ data: Self) -> PetGrowthCacheModel {
    return PetGrowthCacheModel(
      nickname: data.nickname,
      needPoint: data.needPoint,
      levelType: data.levelType.rawValue,
      isLocked: data.isLocked,
      season: data.season.rawValue,
      createdAt: data.createdAt
    )
  }
}
