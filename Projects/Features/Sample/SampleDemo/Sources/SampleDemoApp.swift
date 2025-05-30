//
//  SampleDemoApp.swift
//
//  Sample
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

@main
struct SampleDemoApp: App {
  let store = Store(initialState: SampleReducer.State(), reducer: {
    SampleReducer()
  })

  var body: some Scene {
    WindowGroup {
      SampleView(store: store)
    }
  }
}


