//
//  LevelUpXCTest.swift
//
//  LevelUp
//
//  Created by Jiyeon
//

import Testing
import ComposableArchitecture

@testable import LevelUp

@MainActor
struct LevelUpFeatureTest {
  @Test
  func addTest() async {
    let store = TestStore(
      initialState: LevelUpFeature.State(),
      reducer: { LevelUpFeature() }
    )
    
    await store.send(\.addButtonTapped) {
      $0.count += 1
    }
  }
  
}

