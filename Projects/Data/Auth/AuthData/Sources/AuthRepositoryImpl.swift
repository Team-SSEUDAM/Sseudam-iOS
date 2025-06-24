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
  static var test: AuthRepository {
    AuthRepository(fetchData: {
      return
    }, requestAppleLogin: { token in
      return .init(isTempToken: true, accessToKen: "ㅇㅇ", refreshToken: "ㅇㅇ")
      
    })
  }
}
