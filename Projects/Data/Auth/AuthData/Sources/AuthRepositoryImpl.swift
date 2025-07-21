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
import NetworkKit
import Cache

public extension AuthRepository {
  static func live(networker: NetworkKit) -> AuthRepository {
    AuthRepository(
      requestAppleLogin: { token in
        let endpoint = AuthEndpoint.appleLogin(body: .init(token: token))
        return try await networker.execute(with: endpoint, timeout: 60).toEntity()
        
      },
      requestSignUp: { input in
        let body: SignUpBody = .init(
          email: input.email,
          name: input.nickname,
          address: input.address
        )
        let endpoint = AuthEndpoint.signUp(body: body)
        return try await networker.execute(with: endpoint, timeout: 60).toEntity()
      },
      logout: {
        let endpoint = AuthEndpoint.logout()
        let _ = try await networker.execute(with: endpoint, timeout: 30)

        return ()
      },
      removeUserInfoCache: {
        /// 유저 정보 관련 캐시를 제거
        let mypetInfoCache = try await CacheActor.shared.MY_PET_INFO_CACHE
        let myPetSeasonInfoCache = try await CacheActor.shared.MY_PET_SEASON_INFO_CACHE
        await mypetInfoCache.removeAll()
        await myPetSeasonInfoCache.removeAll()
      }
    )
  }
}
