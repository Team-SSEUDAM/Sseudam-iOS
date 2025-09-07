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
import Mixpanel
import ComposableArchitecture
import AnalyticsKit

@main
struct SseudamApp: App {
  
  let store: StoreOf<SseudamFeature>
  
  init() {
    if let id = Bundle.main.infoDictionary?["NMCLIENTID"] as? String{ NMFAuthManager.shared().ncpKeyId = id }
    let token = Bundle.main.infoDictionary?["MIXPANEL_TOKEN"] as? String ?? ""
    DependencyRegister().injection()
    
    self.store = Store(initialState: SseudamFeature.State()) {
      SseudamFeature()
    } withDependencies: {
      $0.analytics = .mixpanel(token: token, trackAutomaticEvents: false)
    }
  }
  
  var body: some Scene {
    WindowGroup {
      SseudamView(store: store)
    }
  }
}

