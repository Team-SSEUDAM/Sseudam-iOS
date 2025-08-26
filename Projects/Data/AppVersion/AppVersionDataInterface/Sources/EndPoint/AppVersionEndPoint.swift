//
//  AppVersionEndPoint.swift
//  AppVersionDataInterface
//
//  Created by 조용인 on 8/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import AppVersionDomainInterface
import NetworkKit
import UserDefaults

public struct AppVersionEndPoint: Sendable {
  public static func checkAppVersion() -> Endpoint<AppVersionDTO> {
    return Endpoint(
      headers: .plain,
      method: .get,
      path: "/versions/app",
      parameters: .query([
        "deviceType": "IOS",
      ])
    )
  }
}
