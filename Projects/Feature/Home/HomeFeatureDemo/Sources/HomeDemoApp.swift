//
//  HomeDemoApp.swift
//
//  Home
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

@main
struct HomeDemoApp: App {
  let store = Store(initialState: HomeReducer.State(), reducer: {
    HomeReducer()
  })

  var body: some Scene {
    WindowGroup {
      HomeView(store: store)
    }
  }
}


