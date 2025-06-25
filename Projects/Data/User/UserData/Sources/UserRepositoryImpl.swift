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
    UserRepository(
      fetchData: {
        // 실제 네트워크 작업 구현
        return
      }, checkNicknameValidate: { nickname in
        return .init(isValid: true, message: "")
      }
    )
  }
}
