//
//  ReportDemoApp.swift
//
//  Report
//
//  Created by yongin
//

import SwiftUI
import NMapsMap
import ReportFeature
import ComposableArchitecture

@main
struct ReportDemoApp: App {
  init() {
    if let id = Bundle.main.infoDictionary?["NMCLIENTID"] as? String {
      NMFAuthManager.shared().ncpKeyId = id
    }
  }
  let store = Store(initialState: ReportFeature.State(), reducer: {
    ReportFeature()
  })

  var body: some Scene {
    WindowGroup {
      ReportView(store: store)
    }
  }
}


