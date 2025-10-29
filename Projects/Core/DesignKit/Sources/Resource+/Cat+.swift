//
//  Cat+.swift
//  DesignKit
//
//  Created by 조용인 on 7/17/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

// MARK: - Enum Types
public enum CatType: String, Sendable, CaseIterable {
  case _2025_07 = "2025-07"
  case _2025_08 = "2025-08"
  case _2025_09 = "2025-09"
  case _2025_10 = "2025-10"
  case _2025_11 = "2025-11"
  
  public var rawString: String {
    switch self {
    case ._2025_07: return "basic"
    case ._2025_08: return "basic"
    case ._2025_09: return "basic"
    case ._2025_10: return "nov"
    case ._2025_11: return "nov"
    }
  }
}

public enum CatLevel: String, Sendable, CaseIterable {
  case level1 = "LEVEL_1"
  case level2 = "LEVEL_2"
  case level3 = "LEVEL_3"
  case level4 = "LEVEL_4"
  case level5 = "SPECIAL"
  
  public var rawInt: Int {
    switch self {
    case .level1: return 1
    case .level2: return 2
    case .level3: return 3
    case .level4: return 4
    case .level5: return 5
    }
  }
  
  public var levelText: String {
    switch self {
    case .level1:
      return "Lv. 1"
    case .level2:
      return "Lv. 2"
    case .level3:
      return "Lv. 3"
    case .level4:
      return "Lv. 4"
    case .level5:
      return "Special"
    }
  }
  
  public var nextLevel: CatLevel? {
    switch self {
    case .level1: return .level2
    case .level2: return .level3
    case .level3: return .level4
    case .level4: return .level5
    case .level5: return nil
    }
  }
  
  public var interactionText: [String] {
    switch self {
    case .level1: return ["안녕..?", "반가워", "나랑 친구해주는 거야?", "여기 따뜻하고 좋다..~"]
    case .level2: return ["또 보네~", "자주 보자 우리", "안녕~", "나 심심해~"]
    case .level3: return ["오늘 하루는 어땠어?!", "나랑 놀아줄 사람~", "나 많이 컸지~~", "너랑 노는 거 너무 재밌어⚡️"]
    case .level4: return ["나 요즘 행복해~~", "항상 고마워🩵", "오늘은 뭐하고 놀까?", "쓰담쓰담해주세요~~"]
    case .level5: return ["₍^ >ヮ<^₎ .ᐟ.ᐟ", "오늘 기분 최고!!", "너와 함께라 행복해🩵", "넌 진짜 짱이야!", "보고싶었어~~"]
    }
  }
}

// MARK: - DesignKitImages Extension
public extension DesignKitImages {
  
  /// 파라미터로 이미지를 생성하는 생성자
  /// - Parameters:
  ///   - type: 캣 타입 (basic, premium 등)
  ///   - level: 레벨 (1-5)
  ///   - interaction: 상호작용 여부
  init(type: CatType, level: CatLevel, interaction: Bool) {
    let imageName = "type:\(type.rawString)_\(level.rawInt), interaction:\(interaction)"
    self.init(name: imageName)
  }
  
  /// 편의 생성자 - Int 레벨을 받는 버전
  /// - Parameters:
  ///   - type: 캣 타입
  ///   - level: 레벨 (1-5)
  ///   - interaction: 상호작용 여부
  init?(type: CatType, level: String, interaction: Bool) {
    guard let catLevel = CatLevel(rawValue: level) else { return nil }
    self.init(type: type, level: catLevel, interaction: interaction)
  }
}

// MARK: - 편의 메소드들
public struct CatImageSet {
  public static func imgae(level: CatLevel?, interaction: Bool = true, type: CatType) -> DesignKitImages {
    return DesignKitImages(type: type, level: level ?? .level1, interaction: interaction)
  }
  
  public static func image(name: String) -> Image {
    return DesignKitImages(name: name).swiftUIImage
  }
  
  public static func imageURL(level: CatLevel, type: CatType, interaction: Bool = true) -> String { "type:\(type.rawString)_\(level.rawInt), interaction:\(interaction)" }
}
