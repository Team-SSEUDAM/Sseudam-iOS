//
//  MyPetInfoCacheModel.swift
//  Cache
//
//  Created by 조용인 on 7/16/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct MyPetInfoCacheModel: Sendable, Equatable, Codable {
  public let nickname: String
  public let currentPoint: Int
  public let goalPoint: Int
  public let levelType: String
  
  public init(
    nickname: String,
    point: Int,
    levelType: String,
    maxLevelStandard: Int
  ) {
    self.nickname = nickname
    self.currentPoint = point
    self.goalPoint = maxLevelStandard
    self.levelType = levelType
  }
}
