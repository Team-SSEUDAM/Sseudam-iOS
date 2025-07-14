//
//  UserInfoDTO.swift
//  UserDataInterface
//
//  Created by Jiyeon on 7/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import UserDomainInterface
import NetworkKit

public struct UserInfoDTO : DTO{
  public let id: Int
  public let email: String
  public let name: String?
  public let nickname: String
  
  public func toEntity() throws -> UserInfoEntity {
    return .init(
      id: id,
      email: email,
      name: name,
      nickname: nickname
    )
  }
}
