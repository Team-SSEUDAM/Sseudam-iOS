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

public struct AuthEndpoint: Sendable {
  public static func appleLogin(body: SocialLoginBody) -> Endpoint<SocialLoginDTO> {
    return Endpoint(
      method: .post,
      path: "/auth/social-login/apple",
      parameters: .body(body)
    )
  }
  
  public static func signUp(body: SignUpBody) -> Endpoint<SignUpDTO> {
    return Endpoint(
      method: .post,
      path: "/auth/social-signup",
      parameters: .body(body)
    )
  }
}
