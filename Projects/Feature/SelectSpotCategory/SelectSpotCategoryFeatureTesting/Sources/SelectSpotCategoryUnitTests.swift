//
//  SelectSpotCategoryXCTest.swift
//
//  SelectSpotCategory
//
//  Created by yongin
//

import Testing
import ComposableArchitecture

@testable import SelectSpotCategory

@MainActor
struct SelectSpotCategoryFeatureTest {
  @Test
  func addTest() async {
    let store = TestStore(
      initialState: SelectSpotCategoryFeature.State(),
      reducer: { SelectSpotCategoryFeature() }
    )
    
    await store.send(\.addButtonTapped) {
      $0.count += 1
    }
  }
  
}

