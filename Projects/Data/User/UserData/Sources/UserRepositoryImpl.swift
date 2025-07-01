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
import NetworkKit
import Utility

public extension UserRepository {
  static func live(networker: NetworkKit) -> UserRepository {
    let cache = AreaListCache()
    
    return UserRepository(
      checkNicknameValidate: { nickname in
        let endpoint = UserEndPoint.nicknameValid(body: .init(nickname: nickname))
        return try await networker.execute(with: endpoint, timeout: 60).toEntity()
      }, loadAreaList: {
        await cache.load()
      }, fetchAreaList: {
        await cache.fetchList()
      }, deleteAreaList: {
        await cache.deleteAll()
      }
    )
  }
}
