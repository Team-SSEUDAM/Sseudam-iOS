//
//  ReportDemoApp.swift
//
//  Report
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

@main
struct ReportDemoApp: App {
  let store = Store(initialState: ReportReducer.State(), reducer: {
    ReportReducer()
  })

  var body: some Scene {
    WindowGroup {
      ReportView(store: store)
    }
  }
}


