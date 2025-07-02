//
//  SelectSpotLocationDemoApp.swift
//
//  SelectSpotLocation
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

@main
struct SelectSpotLocationDemoApp: App {
  let store = Store(initialState: SelectSpotLocationReducer.State(), reducer: {
    SelectSpotLocationReducer()
  })

  var body: some Scene {
    WindowGroup {
      SelectSpotLocationView(store: store)
    }
  }
}


