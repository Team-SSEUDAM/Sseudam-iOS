//
//  SelectSpotCategoryDemoApp.swift
//
//  SelectSpotCategory
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

@main
struct SelectSpotCategoryDemoApp: App {
  let store = Store(initialState: SelectSpotCategoryReducer.State(), reducer: {
    SelectSpotCategoryReducer()
  })

  var body: some Scene {
    WindowGroup {
      SelectSpotCategoryView(store: store)
    }
  }
}


