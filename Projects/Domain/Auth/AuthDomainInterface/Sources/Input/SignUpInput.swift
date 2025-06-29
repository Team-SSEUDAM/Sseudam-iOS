//
//  SignUpInput.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct SignUpInput {
  public var email: String
  public var nickname: String
  public var address: String
  
  public init(email: String, nickname: String, address: String) {
    self.email = email
    self.nickname = nickname
    self.address = address
  }
}
