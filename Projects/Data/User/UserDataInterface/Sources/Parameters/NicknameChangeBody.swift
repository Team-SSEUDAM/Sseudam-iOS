//
//  NicknameChangeBody.swift
//  UserDataInterface
//
//  Created by 조용인 on 8/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct NicknameChangeBody: Encodable {
  let nickname: String
  
  public init(nickname: String) {
    self.nickname = nickname
  }
}
