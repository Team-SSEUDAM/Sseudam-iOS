//
//  AuthRepositoryImpl.swift
//
//  Auth
//
//  Created by JiYeon
//

import Foundation
import AuthDomainInterface
import AuthDataInterface
import NetworkKit

public extension AuthRepository {
  static func live(networker: NetworkKit) -> AuthRepository {
    AuthRepository(
      requestAppleLogin: { token in
        let endpoint = AuthEndpoint.appleLogin(body: .init(token: token))
        return try await networker.execute(with: endpoint, timeout: 60).toEntity()
        
      },
      requestSignUp: { input in
        let body: SignUpBody = .init(
          email: input.email,
          name: input.nickname,
          address: input.address
        )
        let endpoint = AuthEndpoint.signUp(body: body)
        return try await networker.execute(with: endpoint, timeout: 60).toEntity()
      }
    )
  }
}
