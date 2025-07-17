//
//  Cat+.swift
//  DesignKit
//
//  Created by 조용인 on 7/17/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

// MARK: - Enum Types
public enum CatType: String, Sendable, CaseIterable {
  case basic = "basic"
  /// 추후 다른 타입들 추가 가능
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
}

// MARK: - DesignKitImages Extension
public extension DesignKitImages {
  
  /// 파라미터로 이미지를 생성하는 생성자
  /// - Parameters:
  ///   - type: 캣 타입 (basic, premium 등)
  ///   - level: 레벨 (1-5)
  ///   - interaction: 상호작용 여부
  init(type: CatType, level: CatLevel, interaction: Bool) {
    let imageName = "type:\(type.rawValue)_\(level.rawInt), interaction:\(interaction)"
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
  public static func imgae(level: CatLevel?, interaction: Bool, type: CatType) -> DesignKitImages {
    return DesignKitImages(type: type, level: level ?? .level1, interaction: interaction)
  }
}
