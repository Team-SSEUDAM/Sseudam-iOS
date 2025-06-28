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
  public var loadAreaList: @Sendable () async throws -> Void
  public var fetchAreaList: @Sendable () async throws -> [String]
  public var deleteAreaList: @Sendable () async throws -> Void

  public init(
    checkNicknameValidate: @Sendable @escaping (String) async throws -> NicknameValidEntity,
    loadAreaList: @Sendable @escaping () async throws -> Void,
    fetchAreaList: @Sendable @escaping () async throws -> [String],
    deleteAreaList: @Sendable @escaping () async throws -> Void
  ) {
    self.checkNicknameValidate = checkNicknameValidate
    self.loadAreaList = loadAreaList
    self.fetchAreaList = fetchAreaList
    self.deleteAreaList = deleteAreaList
  }
}
