//
//  AuthRepository.swift
//
//  AuthDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct AuthRepository {
  public var requestAppleLogin: @Sendable (_ token: String) async throws -> SocialLoginEntity
  public var requestSignUp: @Sendable (SignUpInput) async throws -> Void
  public var logout: @Sendable () async throws -> Void
  public var removeUserInfoCache: @Sendable () async throws -> Void
  

  public init(
    requestAppleLogin: @Sendable @escaping (_ token: String) async throws -> SocialLoginEntity,
    requestSignUp: @Sendable @escaping (SignUpInput) async throws -> Void,
    logout: @Sendable @escaping () async throws -> Void,
    removeUserInfoCache: @Sendable @escaping () async throws -> Void
  ) {
    self.requestAppleLogin = requestAppleLogin
    self.requestSignUp = requestSignUp
    self.logout = logout
    self.removeUserInfoCache = removeUserInfoCache
  }
}
