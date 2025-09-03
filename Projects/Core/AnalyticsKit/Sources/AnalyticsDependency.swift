//
//  AnalyticsDependency.swift
//  AnalyticsKit
//
//  Created by 조용인 on 9/3/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture

private enum AnalyticsClientKey: DependencyKey {
  static let liveValue: AnalyticsClient = .noop
  static let testValue: AnalyticsClient = .noop
}

public extension DependencyValues {
  var analytics: AnalyticsClient {
    get { self[AnalyticsClientKey.self] }
    set { self[AnalyticsClientKey.self] = newValue }
  }
}
