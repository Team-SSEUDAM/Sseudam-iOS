//
//  SuggestionDemoApp.swift
//
//  Suggestion
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

@main
struct SuggestionDemoApp: App {
  let store = Store(initialState: SuggestionReducer.State(), reducer: {
    SuggestionReducer()
  })

  var body: some Scene {
    WindowGroup {
      SuggestionView(store: store)
    }
  }
}


