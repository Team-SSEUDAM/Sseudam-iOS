//
//  UserDefaultsKeys.swift
//  UserDefaultsKeys
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct UserDefaultsKeys {
  
  // MARK: - User
  
  @UserDefault("accessToken", default: nil)
  public static var accessToken: String?
  
  @UserDefault("isLoggedIn", default: false)
  public static var isLoggedIn: Bool?
  
  @UserDefault("username", default: nil)
  public static var username: String?
  
  @UserDefault("userId", default: nil)
  public static var userId: Int?
  
  @UserDefault("userNickname", default: nil)
  public static var userNickname: String?
  
  @UserDefault("userLocation", default: nil)
  public static var userLocation: String?
  
  // MARK: - CoachMark
  
  @UserDefault("coachMark_suggestion", default: nil)
  public static var coachMark_suggestion: Bool?
  
  // MARK: - Level
  
  @UserDefault("current_catlevel", default: nil)
  public static var current_catlevel: Int?
  
  @UserDefault("isNeedLevelUp", default: false)
  public static var isNeedLevelUp: Bool? // true일 경우 레벨업 화면 등장
  
}
