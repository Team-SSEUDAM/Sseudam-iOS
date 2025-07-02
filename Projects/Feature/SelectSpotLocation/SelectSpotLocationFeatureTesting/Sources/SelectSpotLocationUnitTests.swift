//
//  SelectSpotLocationXCTest.swift
//
//  SelectSpotLocation
//
//  Created by yongin
//

import Testing
import ComposableArchitecture

@testable import SelectSpotLocation

@MainActor
struct SelectSpotLocationFeatureTest {
  @Test
  func addTest() async {
    let store = TestStore(
      initialState: SelectSpotLocationFeature.State(),
      reducer: { SelectSpotLocationFeature() }
    )
    
    await store.send(\.addButtonTapped) {
      $0.count += 1
    }
  }
  
}

