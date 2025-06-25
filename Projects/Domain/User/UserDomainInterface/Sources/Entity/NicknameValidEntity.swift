//
//  NicknameValidEntity.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 6/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct NicknameValidEntity {
  public var isValid: Bool
  public var message: String?
  
  public init(
    isValid: Bool,
    message: String? = nil
  ) {
    self.isValid = isValid
    self.message = message
  }
}
