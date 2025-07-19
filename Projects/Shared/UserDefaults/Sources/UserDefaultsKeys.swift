//
//  UserDefaultsKeys.swift
//  UserDefaultsKeys
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct UserDefaultsKeys {
  @UserDefault("accessToken", default: nil)
  public static var accessToken: String?
  
  @UserDefault("isLoggedIn", default: false)
  public static var isLoggedIn: Bool?
  
  @UserDefault("username", default: nil)
  public static var username: String?
  
  @UserDefault("userId", default: nil)
  public static var userId: Int?
  
}
