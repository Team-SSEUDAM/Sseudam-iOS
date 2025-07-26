//
//  PetHistoryInfoEntity.swift
//  PetDomainInterface
//
//  Created by 조용인 on 7/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import DesignKit
import Cache

public struct PetHistoryInfoEntity: Sendable, Equatable {
  
  public let petHistory: [PetHistoryEachInfo] /// 고양이 시즌별 정보
  
  public init(
    petHistory: [PetHistoryEachInfo]
  ) {
    self.petHistory = petHistory
  }
  
  public func makeCacheModel() {
    
  }
}

public struct PetHistoryEachInfo: Sendable, Equatable {
  public let nickname: String /// 해당 시즌의 고양이 이름 (관형사 포함)
  public let point: Int /// 해당 시즌의 고양이 포인트
  public let levelType: CatLevel /// 해당 레벨의 타입
  public let season: CatType /// 현재 시즌 이름 (ex. `basic`)
  
  public init(
    nickname: String,
    point: Int,
    levelType: String,
    season: String
  ) {
    self.nickname = nickname
    self.point = point
    self.levelType = CatLevel(rawValue: levelType) ?? .level1
    self.season = CatType(rawValue: season) ?? ._2025_07
  }
}
