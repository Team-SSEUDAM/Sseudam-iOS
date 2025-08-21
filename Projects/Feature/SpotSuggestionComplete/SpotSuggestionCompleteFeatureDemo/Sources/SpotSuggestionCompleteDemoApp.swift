//
//  SpotSuggestionCompleteDemoApp.swift
//
//  SpotSuggestionComplete
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

@main
struct SpotSuggestionCompleteDemoApp: App {
  let store = Store(initialState: SpotSuggestionCompleteReducer.State(), reducer: {
    SpotSuggestionCompleteReducer()
  })

  var body: some Scene {
    WindowGroup {
      SpotSuggestionCompleteView(store: store)
    }
  }
}


