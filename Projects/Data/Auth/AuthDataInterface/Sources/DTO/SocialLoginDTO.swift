//
//  SocialLoginDTO.swift
//  AuthDataInterface
//
//  Created by Jiyeon on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import AuthDomainInterface

public struct LoginDTO {
  public var isTemporaryToken: Bool
  public var accessToken: String
  public var refreshToken: String
  
  
}

extension LoginDTO {
  public func toEntity() throws -> SocialLoginEntity {
    return .init(
      isTempToken: isTemporaryToken,
      accessToKen: accessToken,
      refreshToken: refreshToken
    )
  }
}
