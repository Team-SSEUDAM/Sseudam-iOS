//
//  LogoutBody.swift
//  AuthDataInterface
//
//  Created by Jiyeon on 7/13/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct LogoutBody: Encodable {
  let token: String
  
  public init(token: String) {
    self.token = token
  }
}
