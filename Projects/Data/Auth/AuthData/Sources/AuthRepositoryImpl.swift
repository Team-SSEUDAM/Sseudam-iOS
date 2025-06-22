//
//  AuthRepositoryImpl.swift
//
//  Auth
//
//  Created by JiYeon
//

import Foundation
import AuthDomainInterface
import AuthDataInterface
//import Core

public extension AuthRepository {
  static var live: AuthRepository {
    AuthRepository(
      fetchData: {
        // 실제 네트워크 작업 구현
        return
      }
    )
  }
}
