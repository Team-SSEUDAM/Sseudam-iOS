//
//  SuggestionXCTest.swift
//
//  Suggestion
//
//  Created by yongin
//

import Testing
import ComposableArchitecture

@testable import Suggestion

@MainActor
struct SuggestionFeatureTest {
  @Test
  func addTest() async {
    let store = TestStore(
      initialState: SuggestionFeature.State(),
      reducer: { SuggestionFeature() }
    )
    
    await store.send(\.addButtonTapped) {
      $0.count += 1
    }
  }
  
}

