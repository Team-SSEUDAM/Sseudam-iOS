//
//  LevelUpDemoApp.swift
//
//  LevelUp
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture

@main
struct LevelUpDemoApp: App {
  let store = Store(initialState: LevelUpReducer.State(), reducer: {
    LevelUpReducer()
  })

  var body: some Scene {
    WindowGroup {
      LevelUpView(store: store)
    }
  }
}


