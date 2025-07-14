//
//  UserInfoEntity.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 7/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct UserInfoEntity: Equatable {
  public let id: Int
  public let email: String
  public let name: String?
  public let nickname: String
  
  public init(
    id: Int,
    email: String,
    name: String?,
    nickname: String
  ) {
    self.id = id
    self.email = email
    self.name = name
    self.nickname = nickname
  }
}
