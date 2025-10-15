//
//  NotificationDemoApp.swift
//
//  Notification
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture

@main
struct NotificationDemoApp: App {
  let store = Store(initialState: NotificationReducer.State(), reducer: {
    NotificationReducer()
  })

  var body: some Scene {
    WindowGroup {
      NotificationView(store: store)
    }
  }
}


