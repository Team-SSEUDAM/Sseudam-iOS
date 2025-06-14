//
//  SseudamApp.swift
//  Sseudam
//
//  Created by Jiyeon on 6/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import NMapsMap

@main
struct SseudamApp: App {
  init() {
    if let id = Bundle.main.infoDictionary?["NMCLIENTID"] as? String {
      NMFAuthManager.shared().ncpKeyId = id 
    }
  }
  var body: some Scene {
    WindowGroup {
      SseudamView()
    }
  }
}

