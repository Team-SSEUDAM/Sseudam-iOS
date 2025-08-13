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
      }, changeNickname: { nickname in
        let endpoint = UserEndPoint.updateNickname(body: .init(nickname: nickname))
        let _ = try await networker.execute(with: endpoint, timeout: 60)
      }, loadAreaList: {
        await cache.load()
      }, fetchAreaList: {
        await cache.fetchList()
      }, deleteAreaList: {
        await cache.deleteAll()
      }, withdrawal: {
        let endpoint = UserEndPoint.withdrawal()
        let _ = try await networker.execute(with: endpoint, timeout: 30)
        return ()
      }, fetchUserInfo: {
        let endpoint = UserEndPoint.fetchUserInfo()
        return try await networker.execute(with: endpoint, timeout: 30).toEntity()
      }
    )
  }
}
