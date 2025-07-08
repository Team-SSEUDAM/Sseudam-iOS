//
//  MyPetXCTest.swift
//
//  MyPet
//
//  Created by yongin
//

import Testing
import ComposableArchitecture

@testable import MyPet

@MainActor
struct MyPetFeatureTest {
  @Test
  func addTest() async {
    let store = TestStore(
      initialState: MyPetFeature.State(),
      reducer: { MyPetFeature() }
    )
    
    await store.send(\.addButtonTapped) {
      $0.count += 1
    }
  }
  
}

