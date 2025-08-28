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
      let accessToken = UserDefaultsKeys.accessToken
      let refreshEndpoint = Endpoint<TokenRefreshDTO>(
        headers: .reissue(accessToken),
        method: .post,
        path: "/auth/reissue",
        parameters: .body(ReissueTokenBody(refreshToken: refreshToken)),
        isRefreshToken: true
      )
      do {
        let response = try await NetworkKit().execute(with: refreshEndpoint)
        KeyChainService.save(response.refreshToken, forKey: .refreshToken)
        UserDefaultsKeys.accessToken = response.accessToken
        return response.accessToken
      } catch {
        print(accessToken ?? "")
        print(refreshToken)
        UserDefaultsKeys.isLoggedIn = false
        KeyChainService.delete(forKey: .refreshToken)
        UserDefaultsKeys.accessToken = nil
        throw TokenError.invalidToken
      }
      
    }
    throw TokenError.invalidToken
  }
}
