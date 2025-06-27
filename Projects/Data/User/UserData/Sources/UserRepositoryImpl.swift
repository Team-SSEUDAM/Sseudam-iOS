//
//  UserRepositoryImpl.swift
//
//  User
//
//  Created by JiYeon
//

import Foundation
import UserDomainInterface
import UserDataInterface
import Core

public extension UserRepository {
  static var test: UserRepository {
    let cache = LocationCache()
    return UserRepository(
      checkNicknameValidate: { nickname in
        return .init(isValid: true, message: "")
      }, loadLocationList: {
        await cache.load()
      }, fetchLocationList: {
        await cache.fetchList()
      }
    )
  }
}
