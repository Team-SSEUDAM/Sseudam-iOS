//
//  AuthDemoApp.swift
//
//  Auth
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

@main
struct AuthDemoApp: App {
  let store = Store(initialState: AuthReducer.State(), reducer: {
    AuthReducer()
  })

  var body: some Scene {
    WindowGroup {
      AuthView(store: store)
    }
  }
}


