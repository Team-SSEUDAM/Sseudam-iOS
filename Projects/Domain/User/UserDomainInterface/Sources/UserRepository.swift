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
  public var changeNickname: @Sendable (String) async throws -> Void
  public var loadAreaList: @Sendable () async throws -> Void
  public var fetchAreaList: @Sendable () async throws -> [String]
  public var deleteAreaList: @Sendable () async throws -> Void
  public var withdrawal: @Sendable () async throws -> Void
  public var fetchUserInfo: @Sendable () async throws -> UserInfoEntity

  public init(
    checkNicknameValidate: @Sendable @escaping (String) async throws -> NicknameValidEntity,
    changeNickname: @Sendable @escaping (String) async throws -> Void,
    loadAreaList: @Sendable @escaping () async throws -> Void,
    fetchAreaList: @Sendable @escaping () async throws -> [String],
    deleteAreaList: @Sendable @escaping () async throws -> Void,
    withdrawal: @Sendable @escaping () async throws -> Void,
    fetchUserInfo: @Sendable @escaping () async throws -> UserInfoEntity
  ) {
    self.checkNicknameValidate = checkNicknameValidate
    self.changeNickname = changeNickname
    self.loadAreaList = loadAreaList
    self.fetchAreaList = fetchAreaList
    self.deleteAreaList = deleteAreaList
    self.withdrawal = withdrawal
    self.fetchUserInfo = fetchUserInfo
  }
}
