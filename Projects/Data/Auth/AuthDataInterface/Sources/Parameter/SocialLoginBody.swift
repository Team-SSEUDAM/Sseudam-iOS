//
//  SocialLoginBody.swift
//  AuthDataInterface
//
//  Created by Jiyeon on 6/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct SocialLoginBody: Encodable {
  let token: String
  public init(token: String) {
    self.token = token
  }
}
