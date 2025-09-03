//
//  AnalyticsClient.swift
//  AnalyticsKit
//
//  Created by 조용인 on 9/3/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility
import ComposableArchitecture

public struct AnalyticsClient: Sendable {
  public var track: @Sendable (_ event: MixPanelEvent, _ props: [String: Any]?) -> Void
  public var identify: @Sendable (_ userId: String) -> Void
  public var alias: @Sendable (_ userId: String) -> Void
  public var setUserProperties: @Sendable (_ props: [String: Any]) -> Void
  public var registerSuperProperties: @Sendable (_ props: [String: Any], _ once: Bool) -> Void
  public var setTracking: @Sendable (_ enabled: Bool) -> Void
  public var reset: @Sendable () -> Void

  public init(
    track: @escaping @Sendable (_: MixPanelEvent, _: [String: Any]?) -> Void,
    identify: @escaping @Sendable (_: String) -> Void,
    alias: @escaping @Sendable (_: String) -> Void,
    setUserProperties: @escaping @Sendable (_: [String: Any]) -> Void,
    registerSuperProperties: @escaping @Sendable (_: [String: Any], _ once: Bool) -> Void,
    setTracking: @escaping @Sendable (_: Bool) -> Void,
    reset: @escaping @Sendable () -> Void
  ) {
    self.track = track
    self.identify = identify
    self.alias = alias
    self.setUserProperties = setUserProperties
    self.registerSuperProperties = registerSuperProperties
    self.setTracking = setTracking
    self.reset = reset
  }
}

public extension AnalyticsClient {
  /// 아무 것도 하지 않는 기본 구현
  static let noop = AnalyticsClient(
    track: { _, _ in }, identify: { _ in }, alias: { _ in },
    setUserProperties: { _ in }, registerSuperProperties: { _, _ in },
    setTracking: { _ in }, reset: {}
  )

  /// Encodable props를 편하게 보낼 수 있는 헬퍼
  @inlinable
  func track<E: Encodable>(_ event: MixPanelEvent, encodable props: E?) {
    track(event, try? props?.toDictionary())
  }
}
