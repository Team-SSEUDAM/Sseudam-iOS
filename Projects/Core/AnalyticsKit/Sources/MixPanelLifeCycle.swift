//
//  MixPanelLifeCycle.swift
//  AnalyticsKit
//
//  Created by 조용인 on 9/3/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Mixpanel
#if canImport(UIKit)
import UIKit
#endif

/// 앱 라이프사이클과 묶어서 flush 등 필요한 훅을 단다.
final class MixpanelLifecycle {
  static let shared = MixpanelLifecycle()
  private var isActive = false

  private init() {}

  func activate() {
    guard !isActive else { return }
    isActive = true

    #if canImport(UIKit)
    let center = NotificationCenter.default

    center.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { _ in
      Mixpanel.mainInstance().flush()
    }
    center.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { _ in
      Mixpanel.mainInstance().flush()
    }
    #endif
  }
}
