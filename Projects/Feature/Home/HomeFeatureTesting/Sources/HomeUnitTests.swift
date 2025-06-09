//
//  HomeXCTest.swift
//
//  Home
//
//  Created by JiYeon
//

import XCTest
import ComposableArchitecture
@testable import HomeFeature

final class HomeUnitTests: XCTestCase {
    
  func testIncrement() {
    let store = TestStore(initialState: HomeReducer.State()) {
      HomeReducer()
    }

    store.send(.increment) {
      $0.count = 1
    }
  }

  func testDecrement() {
    let store = TestStore(initialState: HomeReducer.State()) {
      HomeReducer()
    }

    store.send(.decrement) {
      $0.count = -1
    }
  }
}

