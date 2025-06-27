//
//  UserRepository.swift
//
//  UserDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct UserRepository {
  public var checkNicknameValidate: @Sendable (String) async throws -> NicknameValidEntity
  public var loadLocationList: @Sendable () async throws -> Void
  public var fetchLocationList: @Sendable () async throws -> [String]

  public init(
    checkNicknameValidate: @Sendable @escaping (String) async throws -> NicknameValidEntity,
    loadLocationList: @Sendable @escaping () async throws -> Void,
    fetchLocationList: @Sendable @escaping () async throws -> [String]
  ) {
    self.checkNicknameValidate = checkNicknameValidate
    self.loadLocationList = loadLocationList
    self.fetchLocationList = fetchLocationList
  }
}
