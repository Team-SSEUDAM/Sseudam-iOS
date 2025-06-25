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
  static var live: UserRepository {
    UserRepository(
      fetchData: {
        // 실제 네트워크 작업 구현
        return
      }
    )
  }
}
