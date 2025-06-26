//
//  SocialLoginEntity.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct SocialLoginEntity: Sendable, Equatable {
  public let isTempToken: Bool
  public let accessToken: String
  public let refreshToken: String
  
  public init(isTempToken: Bool, accessToKen: String, refreshToken: String) {
    self.isTempToken = isTempToken
    self.accessToken = accessToKen
    self.refreshToken = refreshToken
  }
}
