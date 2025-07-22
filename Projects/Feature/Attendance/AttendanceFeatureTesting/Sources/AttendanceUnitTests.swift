//
//  AttendanceXCTest.swift
//
//  Attendance
//
//  Created by Jiyeon
//

import Testing
import ComposableArchitecture

@testable import Attendance

@MainActor
struct AttendanceFeatureTest {
  @Test
  func addTest() async {
    let store = TestStore(
      initialState: AttendanceFeature.State(),
      reducer: { AttendanceFeature() }
    )
    
    await store.send(\.addButtonTapped) {
      $0.count += 1
    }
  }
  
}

