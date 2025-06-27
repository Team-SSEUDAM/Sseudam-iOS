//
//  NicknameValidateBody.swift
//  UserDataInterface
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct NicknameValidateBody: Encodable {
  let nickname: String
  
  public init(nickname: String) {
    self.nickname = nickname
  }
}
