//
//  PetInfoEntity.swift
//
//  PetDomainInterface
//
//  Created by yongin
//

import Foundation
import DesignKit
import Cache

public struct PetInfoEntity: Sendable, Equatable {
  public let nickname: String
  public let currentPoint: Int
  public let goalPoint: Int
  public let levelType: CatLevel
  public let season: CatType
  
  public init(
    nickname: String,
    point: Int,
    levelType: String,
    maxLevelStandard: Int,
    season: String
  ) {
    self.nickname = nickname
    self.currentPoint = point
    self.levelType = CatLevel(rawValue: levelType) ?? .level1
    self.season = CatType(rawValue: season) ?? ._2025_07
    
    if CatLevel(rawValue: levelType) == .level5 { self.goalPoint = point }
    else { self.goalPoint = maxLevelStandard }
  }
  
  /// Cache데이터를 PetInfoEntity로 변환하는 초기화 메서드
  public init(
    _ cacheModel: MyPetInfoCacheModel
  ) {
    self.init(
      nickname: cacheModel.nickname,
      point: cacheModel.currentPoint,
      levelType: cacheModel.levelType,
      maxLevelStandard: cacheModel.goalPoint,
      season: cacheModel.season
    )
  }
  
  public func makeCacheModel() -> MyPetInfoCacheModel {
    return MyPetInfoCacheModel(
      nickname: self.nickname,
      point: self.currentPoint,
      levelType: self.levelType.rawValue,
      maxLevelStandard: self.goalPoint,
      season: self.season.rawValue
    )
  }
}
