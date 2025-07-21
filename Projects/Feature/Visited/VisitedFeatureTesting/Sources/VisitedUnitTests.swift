//
//  VisitedXCTest.swift
//
//  Visited
//
//  Created by Jiyeon
//

import Testing
import ComposableArchitecture

@testable import Visited

@MainActor
struct VisitedFeatureTest {
  @Test
  func addTest() async {
    let store = TestStore(
      initialState: VisitedFeature.State(),
      reducer: { VisitedFeature() }
    )
    
    await store.send(\.addButtonTapped) {
      $0.count += 1
    }
  }
  
}

