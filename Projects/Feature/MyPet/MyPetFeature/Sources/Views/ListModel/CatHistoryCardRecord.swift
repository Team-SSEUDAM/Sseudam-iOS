//
//  CatHistoryCardRecord.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Utility
import DesignKit

public struct CatHistoryCardRecord: Identifiable, Equatable {
  public let id = UUID()
  public let nickname: String
  public let levelType: CatLevel /// 고양이 레벨 타입
  public let imageURL: String /// 고양이 이미지 URL
  
  public init(
    nickname: String,
    imageURL: String,
    levelType: CatLevel
  ) {
    self.nickname = nickname
    self.imageURL = imageURL
    self.levelType = levelType
  }
}
