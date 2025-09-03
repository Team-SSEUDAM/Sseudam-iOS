//
//  SessionTrackerClient.swift
//  AnalyticsKit
//
//  Created by 조용인 on 9/3/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ComposableArchitecture

public struct SessionStartInfo: Equatable, Sendable {
  public let session_id: String
  public let previous_session_duration: TimeInterval?   // 직전 세션 길이(초)
  public let previous_session_gap: TimeInterval?        // 직전 종료 ~ 현재 시작 간격(초)
}

public struct SessionTrackerClient: Sendable {
  public var start: @Sendable (_ now: Date) async -> SessionStartInfo
  public var end:   @Sendable (_ now: Date) async -> Void
  public var currentId: @Sendable () async -> String?
}

private enum SessionTrackerKey: DependencyKey {
  static let liveValue: SessionTrackerClient = .live()
  static let testValue: SessionTrackerClient = .unimplemented
}

public extension DependencyValues {
  var sessionTracker: SessionTrackerClient {
    get { self[SessionTrackerKey.self] }
    set { self[SessionTrackerKey.self] = newValue }
  }
}

// MARK: - Live 구현

public extension SessionTrackerClient {
  static func live(userDefaults: UserDefaults = .standard) -> Self {
    let storage = SessionStorage(userDefaults: userDefaults)
    return .init(
      start: { now in await storage.start(now: now) },
      end:   { now in await storage.end(now: now) },
      currentId: { await storage.currentId() }
    )
  }

  static var unimplemented: Self {
    .init(
      start: { _ in .init(session_id: "test", previous_session_duration: nil, previous_session_gap: nil) },
      end: { _ in },
      currentId: { nil }
    )
  }
}

// 내부 상태/동시성 보호
private actor SessionStorage {
  private enum K {
    static let lastStart = "session.last.start"
    static let lastEnd   = "session.last.end"
    static let lastId    = "session.last.id"
  }

  private let ud: UserDefaults
  init(userDefaults: UserDefaults) { self.ud = userDefaults }

  func start(now: Date) -> SessionStartInfo {
    let lastStart = ud.object(forKey: K.lastStart) as? Date
    let lastEnd   = ud.object(forKey: K.lastEnd) as? Date

    let prevDuration: TimeInterval? = {
      guard let s = lastStart, let e = lastEnd else { return nil }
      return max(0, e.timeIntervalSince(s))
    }()

    let prevGap: TimeInterval? = {
      guard let e = lastEnd else { return nil }
      return max(0, now.timeIntervalSince(e))
    }()

    let id = UUID().uuidString
    ud.set(now, forKey: K.lastStart)
    ud.removeObject(forKey: K.lastEnd)
    ud.set(id, forKey: K.lastId)

    return .init(session_id: id,
                 previous_session_duration: prevDuration,
                 previous_session_gap: prevGap)
  }

  func end(now: Date) {
    ud.set(now, forKey: K.lastEnd)
  }

  func currentId() -> String? {
    ud.string(forKey: K.lastId)
  }
}
