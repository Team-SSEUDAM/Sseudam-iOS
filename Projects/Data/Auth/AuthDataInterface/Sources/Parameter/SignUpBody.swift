//
//  SignUpBody.swift
//  AuthDataInterface
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct SignUpBody: Encodable {
  let email: String
  let name: String
  let address: String
  
  public init(email: String, name: String, address: String) {
    self.email = email
    self.name = name
    self.address = address
  }
}
