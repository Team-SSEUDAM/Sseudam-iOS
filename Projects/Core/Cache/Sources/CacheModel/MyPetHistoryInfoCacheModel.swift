//
//  MyPetHistoryInfoCacheModel.swift
//  
//
//  Created by 조용인 on 7/26/25.
//

import Foundation

public struct MyPetHistoryInfoCacheModel: Sendable, Equatable, Codable {
  public let historyInfo: [PetHistoryEachCacheModel]
  
  public init(
    _ historyInfo: [PetHistoryEachCacheModel]
  ) {
    self.historyInfo = historyInfo
  }
}

public struct PetHistoryEachCacheModel: Sendable, Equatable, Codable {
  public let nickname: String
  public let point: Int
  public let levelType: String
  public let season: String
  
  public init(
    nickname: String,
    point: Int,
    levelType: String,
    season: String
  ) {
    self.nickname = nickname
    self.point = point
    self.levelType = levelType
    self.season = season
    
  }
}
