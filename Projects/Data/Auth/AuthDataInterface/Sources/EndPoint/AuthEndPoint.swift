//
//  AuthEndPoint.swift
//  AuthDataInterface
//
//  Created by Jiyeon on 6/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import AuthDomainInterface
import NetworkKit
import UserDefaults

public struct AuthEndpoint: Sendable {
  public static func appleLogin(body: SocialLoginBody) -> Endpoint<SocialLoginDTO> {
    return Endpoint(
      method: .post,
      path: "/auth/social-login/apple",
      parameters: .body(body)
    )
  }
  
  public static func signUp(body: SignUpBody) -> Endpoint<SignUpDTO> {
    let accessToken = UserDefaultsKeys.accessToken
    return Endpoint(
      headers: .authorization(accessToken),
      method: .post,
      path: "/auth/social-signup",
      parameters: .body(body)
    )
  }
  
  public static func logout() ->  Endpoint<EmptyResponse> {
    let accessToken = UserDefaultsKeys.accessToken
    let body = LogoutBody(token: accessToken ?? "")
    return Endpoint(
      headers: .authorization(accessToken),
      method: .post,
      path: "/auth/logout",
      parameters: .body(body)
    )
  }
}
