//
//  ForceUpdateFeature.swift
//  Sseudam
//
//  Created by 조용인 on 8/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct VersionInfo: Equatable {
  let currentVersion: String
  let latestVersion: String
  let criticalVersions: [String]
  
  var updateStatus: UpdateStatus {
    guard currentVersion < latestVersion else { return .notNeeded }
    return criticalVersions.contains(currentVersion)
    ? .required(latestVersion)
    : .optional(latestVersion)
  }
  
  enum UpdateStatus: Equatable {
    case required(String)
    case optional(String)
    case notNeeded
  }
}
