//
//  SseudamApp.swift
//  Sseudam
//
//  Created by Jiyeon on 6/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Utility
import NMapsMap

@main
struct SseudamApp: App {
  init() {
    if let id = Constants.naver_map_client_id {
      NMFAuthManager.shared().ncpKeyId = id
    }
    DependencyRegister().injection()
  }
  var body: some Scene {
    WindowGroup {
      SseudamView()
    }
  }
}

