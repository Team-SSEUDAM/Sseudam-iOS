//
//  SelectSpotImageDemoApp.swift
//
//  SelectSpotImage
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

@main
struct SelectSpotImageDemoApp: App {
  let store = Store(initialState: SelectSpotImageReducer.State(), reducer: {
    SelectSpotImageReducer()
  })

  var body: some Scene {
    WindowGroup {
      SelectSpotImageView(store: store)
    }
  }
}


