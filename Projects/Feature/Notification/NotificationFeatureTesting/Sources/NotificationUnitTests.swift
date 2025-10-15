//
//  NotificationXCTest.swift
//
//  Notification
//
//  Created by Jiyeon
//

import Testing
import ComposableArchitecture

@testable import Notification

@MainActor
struct NotificationFeatureTest {
  @Test
  func addTest() async {
    let store = TestStore(
      initialState: NotificationFeature.State(),
      reducer: { NotificationFeature() }
    )
    
    await store.send(\.addButtonTapped) {
      $0.count += 1
    }
  }
  
}

