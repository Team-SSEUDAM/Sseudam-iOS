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

public extension UserRepository {
  static func live(networker: NetworkKit) -> UserRepository {
    let cache = LocationCache()
    
    return UserRepository(
      checkNicknameValidate: { nickname in
        let endpoint = UserEndPoint.nicknameValid(body: .init(nickname: nickname))
        return try await networker.execute(with: endpoint, timeout: 60).toEntity()
      }, loadLocationList: {
        await cache.load()
      }, fetchLocationList: {
        await cache.fetchList()
      }
    )
  }
}
