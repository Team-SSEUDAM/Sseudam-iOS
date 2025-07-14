//
//  MyPageDemoApp.swift
//
//  MyPage
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture

@main
struct MyPageDemoApp: App {
  let store = Store(initialState: MyPageReducer.State(), reducer: {
    MyPageReducer()
  })

  var body: some Scene {
    WindowGroup {
      MyPageView(store: store)
    }
  }
}


