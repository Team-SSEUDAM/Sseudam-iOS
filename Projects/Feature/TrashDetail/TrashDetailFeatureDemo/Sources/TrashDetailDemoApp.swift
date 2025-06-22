//
//  TrashDetailDemoApp.swift
//
//  TrashDetail
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

@main
struct TrashDetailDemoApp: App {
  let store = Store(initialState: TrashDetailReducer.State(), reducer: {
    TrashDetailReducer()
  })

  var body: some Scene {
    WindowGroup {
      TrashDetailView(store: store)
    }
  }
}


