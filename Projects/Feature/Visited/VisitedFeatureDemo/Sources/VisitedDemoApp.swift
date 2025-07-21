//
//  VisitedDemoApp.swift
//
//  Visited
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture

@main
struct VisitedDemoApp: App {
  let store = Store(initialState: VisitedReducer.State(), reducer: {
    VisitedReducer()
  })

  var body: some Scene {
    WindowGroup {
      VisitedView(store: store)
    }
  }
}


