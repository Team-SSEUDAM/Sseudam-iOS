//
//  UserEndPoint.swift
//  UserDataInterface
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import UserDomainInterface
import NetworkKit

public struct UserEndPoint: Sendable {
  public static func nicknameValid(body: NicknameValidateBody) -> Endpoint<NicknameValidCheckDTO> {
    return Endpoint(
      method: .post,
      path: "/users/nickname/validate",
      parameters: .body(body)
    )
  }
}

