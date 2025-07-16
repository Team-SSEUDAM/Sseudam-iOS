//
//  PetInfoEntity.swift
//
//  PetDomainInterface
//
//  Created by yongin
//

import Foundation
import Cache

public struct PetInfoEntity: Sendable, Equatable {
  public let nickname: String
  public let currentPoint: Int
  public let goalPoint: Int
  public let levelType: LevelType
  
  public init(
    nickname: String,
    point: Int,
    levelType: String,
    maxLevelStandard: Int
  ) {
    self.nickname = nickname
    self.currentPoint = point
    self.goalPoint = maxLevelStandard
    self.levelType = LevelType(rawValue: levelType) ?? .유년기
  }
  
  /// Cache데이터를 PetInfoEntity로 변환하는 초기화 메서드
  public init(
    _ cacheModel: MyPetInfoCacheModel
  ) {
    self.init(
      nickname: cacheModel.nickname,
      point: cacheModel.currentPoint,
      levelType: cacheModel.levelType,
      maxLevelStandard: cacheModel.goalPoint
    )
  }
}

public enum LevelType: String, Sendable {
  case 유년기 = "LEVEL_1"
  case 성장기 = "LEVEL_2"
  case 성숙기 = "LEVEL_3" 
  case 완전체 = "LEVEL_4"
  case 궁극체 = "SPECIAL"
}
