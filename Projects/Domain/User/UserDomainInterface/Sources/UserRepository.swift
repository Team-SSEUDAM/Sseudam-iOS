//
//  UserRepository.swift
//
//  UserDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct UserRepository {
  public var fetchData: @Sendable () async throws -> Void
  public var checkNicknameValidate: @Sendable (String) async throws -> NicknameValidEntity

  public init(
    fetchData: @Sendable @escaping () async throws -> Void,
    checkNicknameValidate: @Sendable @escaping (String) async throws -> NicknameValidEntity
  ) {
    self.fetchData = fetchData
    self.checkNicknameValidate = checkNicknameValidate
  }
}
