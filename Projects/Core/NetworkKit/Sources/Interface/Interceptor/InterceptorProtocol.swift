//
//  InterceptorProtocol.swift
//  NetworkKit
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public protocol TokenRefresher: Sendable {
  static func refreshToken() async throws -> String?
}

public struct TokenRefreshDTO: Sendable, Decodable {
  public var isTemporaryToken: Bool
  public var accessToken: String
  public var refreshToken: String
}

public struct ReissueTokenBody: Encodable {
  public var refreshToken: String
  public init(refreshToken: String) {
    self.refreshToken = refreshToken
  }
}
