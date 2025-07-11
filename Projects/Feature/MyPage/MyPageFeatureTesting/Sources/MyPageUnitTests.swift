//
//  MyPageXCTest.swift
//
//  MyPage
//
//  Created by Jiyeon
//

import Testing
import ComposableArchitecture

@testable import MyPage

@MainActor
struct MyPageFeatureTest {
  @Test
  func addTest() async {
    let store = TestStore(
      initialState: MyPageFeature.State(),
      reducer: { MyPageFeature() }
    )
    
    await store.send(\.addButtonTapped) {
      $0.count += 1
    }
  }
  
}

