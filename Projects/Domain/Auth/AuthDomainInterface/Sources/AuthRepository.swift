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
  public var requestSignUp: @Sendable (
    _ email: String,
    _ nickname: String,
    _ address: String
  ) async throws -> Void

  public init(
    requestAppleLogin: @Sendable @escaping (_ token: String) async throws -> SocialLoginEntity,
    requestSignUp: @Sendable @escaping (
      _ email: String,
      _ nickname: String,
      _ address: String
    ) async throws -> Void
  ) {
    self.requestAppleLogin = requestAppleLogin
    self.requestSignUp = requestSignUp
  }
}
