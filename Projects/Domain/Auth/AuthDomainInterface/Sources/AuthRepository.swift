//
//  AuthRepository.swift
//
//  AuthDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct AuthRepository {
  public var fetchData: @Sendable () async throws -> Void
  public var requestAppleLogin: @Sendable (String) async throws -> SocialLoginEntity

  public init(
    fetchData: @Sendable @escaping () async throws -> Void,
    requestAppleLogin: @Sendable @escaping (String) async throws -> SocialLoginEntity
  ) {
    self.fetchData = fetchData
    self.requestAppleLogin = requestAppleLogin
  }
}
