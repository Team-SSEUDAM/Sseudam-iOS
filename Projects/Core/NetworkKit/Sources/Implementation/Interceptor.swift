//
//  Interceptor.swift
//  NetworkKit
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import KeyChain
import UserDefaults
import Utility

public struct Interceptor: TokenRefresher {
  
  public static func refreshToken() async throws -> String? {
    if let refreshToken: String = KeyChainService.read(forKey: .refreshToken) {
      let refreshEndpoint = Endpoint<TokenRefreshDTO>(
        headers: .plain,
        method: .post,
        path: "/auth/reissue",
        parameters: .body(ReissueTokenBody(refreshToken: refreshToken)),
        isRefreshToken: true
      )
      do {
        let response = try await NetworkKit().execute(with: refreshEndpoint)
        KeyChainService.save(response.refreshToken, forKey: .refreshToken)
        UserDefault.accessToken = response.accessToken
        return response.accessToken
      } catch {
        UserDefault.isLoggedIn = false
        KeyChainService.delete(forKey: .refreshToken)
        UserDefault.accessToken = nil
        throw TokenError.expiredToken
      }
      
    }
    throw TokenError.invalidToken
  }
}
