//
//  GrowthRecord.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/16/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Utility
import DesignKit

public struct GrowthRecord: Identifiable, Equatable {
  public let id = UUID()
  public let catCard: CatCard /// 고양이 카드 정보
  public let levelType: CatLevel /// 고양이 레벨 타입
  public let goalStamp: Int /// 레벨업을 위한 쓰담
  public let nickname: String
  public var didAchieveDate: String? = nil /// 레벨업 달성 날짜 (yy-MM-dd 형식)
  
  public init(
    catCard: CatCard,
    levelType: CatLevel,
    goalStamp: Int,
    nickname: String,
    createdAt: String
  ) {
    self.catCard = catCard
    self.levelType = levelType
    self.goalStamp = goalStamp
    self.nickname = nickname
    self.didAchieveDate = createdAt.toFormattedDateOptional()
  }
}
