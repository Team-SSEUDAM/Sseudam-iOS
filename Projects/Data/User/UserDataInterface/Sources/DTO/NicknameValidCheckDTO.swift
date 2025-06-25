//
//  NicknameValidCheckDTO.swift
//  UserDataInterface
//
//  Created by Jiyeon on 6/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import UserDomainInterface
import NetworkKit

public struct NicknameValidCheckDTO: DTO {
  public typealias Entity = NicknameValidEntity
  
  var isValid: Bool
  var message: String?
  
  public func toEntity() throws -> NicknameValidEntity {
    return .init(
      isValid: isValid,
      message: message
    )
  }
  
  
}
