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
  static var live: AppVersionRepository {
    AppVersionRepository(
      fetchData: {
        // 실제 네트워크 작업 구현
        return
      }
    )
  }
}
