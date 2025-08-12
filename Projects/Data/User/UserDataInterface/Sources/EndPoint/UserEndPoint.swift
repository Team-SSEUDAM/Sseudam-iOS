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
import UserDefaults

public struct UserEndPoint: Sendable {
  public static func nicknameValid(body: NicknameValidateBody) -> Endpoint<NicknameValidCheckDTO> {
    let accessToken = UserDefaultsKeys.accessToken
    return Endpoint(
      headers: .authorization(accessToken),
      method: .post,
      path: "/users/nickname/validate",
      parameters: .body(body)
    )
  }
  
  public static func withdrawal() -> Endpoint<EmptyResponse> {
    let accessToken = UserDefaultsKeys.accessToken
    return Endpoint(
      headers: .authorization(accessToken),
      method: .delete,
      path: "/users"
    )
  }
  
  public static func updateNickname(body: NicknameChangeBody) -> Endpoint<EmptyResponse> {
    let accessToken = UserDefaultsKeys.accessToken
    return Endpoint(
      headers: .authorization(accessToken),
      method: .put,
      path: "/users/nickname",
      parameters: .body(body)
    )
  }
  
  public static func fetchUserInfo() -> Endpoint<UserInfoDTO> {
    let accessToken = UserDefaultsKeys.accessToken
    return Endpoint(
      headers: .authorization(accessToken),
      method: .get,
      path: "/users/me"
    )
  }
}

