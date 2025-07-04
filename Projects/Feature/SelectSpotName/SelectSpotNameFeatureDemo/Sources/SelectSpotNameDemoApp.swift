//
//  SelectSpotNameDemoApp.swift
//
//  SelectSpotName
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

@main
struct SelectSpotNameDemoApp: App {
  let store = Store(initialState: SelectSpotNameReducer.State(), reducer: {
    SelectSpotNameReducer()
  })

  var body: some Scene {
    WindowGroup {
      SelectSpotNameView(store: store)
    }
  }
}


