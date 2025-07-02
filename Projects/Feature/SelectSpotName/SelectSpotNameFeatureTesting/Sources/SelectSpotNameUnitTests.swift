//
//  SelectSpotNameXCTest.swift
//
//  SelectSpotName
//
//  Created by yongin
//

import Testing
import ComposableArchitecture

@testable import SelectSpotName

@MainActor
struct SelectSpotNameFeatureTest {
  @Test
  func addTest() async {
    let store = TestStore(
      initialState: SelectSpotNameFeature.State(),
      reducer: { SelectSpotNameFeature() }
    )
    
    await store.send(\.addButtonTapped) {
      $0.count += 1
    }
  }
  
}

