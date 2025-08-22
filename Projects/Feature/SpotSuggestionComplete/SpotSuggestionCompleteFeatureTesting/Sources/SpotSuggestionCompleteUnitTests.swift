//
//  SpotSuggestionCompleteXCTest.swift
//
//  SpotSuggestionComplete
//
//  Created by yongin
//

import Testing
import ComposableArchitecture

@testable import SpotSuggestionComplete

@MainActor
struct SpotSuggestionCompleteFeatureTest {
  @Test
  func addTest() async {
    let store = TestStore(
      initialState: SpotSuggestionCompleteFeature.State(),
      reducer: { SpotSuggestionCompleteFeature() }
    )
    
    await store.send(\.addButtonTapped) {
      $0.count += 1
    }
  }
  
}

