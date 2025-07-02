//
//  SelectSpotImageXCTest.swift
//
//  SelectSpotImage
//
//  Created by yongin
//

import Testing
import ComposableArchitecture

@testable import SelectSpotImage

@MainActor
struct SelectSpotImageFeatureTest {
  @Test
  func addTest() async {
    let store = TestStore(
      initialState: SelectSpotImageFeature.State(),
      reducer: { SelectSpotImageFeature() }
    )
    
    await store.send(\.addButtonTapped) {
      $0.count += 1
    }
  }
  
}

