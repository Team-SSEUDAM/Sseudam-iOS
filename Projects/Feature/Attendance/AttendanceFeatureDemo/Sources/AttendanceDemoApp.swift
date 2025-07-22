//
//  AttendanceDemoApp.swift
//
//  Attendance
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture

@main
struct AttendanceDemoApp: App {
  let store = Store(initialState: AttendanceReducer.State(), reducer: {
    AttendanceReducer()
  })

  var body: some Scene {
    WindowGroup {
      AttendanceView(store: store)
    }
  }
}


