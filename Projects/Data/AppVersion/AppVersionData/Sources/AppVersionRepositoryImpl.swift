//
//  AppVersionRepositoryImpl.swift
//
//  AppVersion
//
//  Created by yongin
//

import Foundation
import AppVersionDomainInterface
import AppVersionDataInterface
import NetworkKit

public extension AppVersionRepository {
  static func live(networker: NetworkKit) -> AppVersionRepository {
    AppVersionRepository(
      checkAppVersion: {
        let endpoint = AppVersionEndPoint.checkAppVersion()
        return try await networker.execute(with: endpoint, timeout: 30).toEntity()
      }
    )
  }
}
