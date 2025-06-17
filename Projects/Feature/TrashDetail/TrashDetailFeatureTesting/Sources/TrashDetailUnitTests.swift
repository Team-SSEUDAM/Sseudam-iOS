//
//  TrashDetailXCTest.swift
//
//  TrashDetail
//
//  Created by JiYeon
//

import XCTest
import ComposableArchitecture
@testable import TrashDetailInterface

final class TrashDetailUnitTests: XCTestCase {
    
  func testIncrement() {
    let store = TestStore(initialState: TrashDetailReducer.State()) {
      TrashDetailReducer()
    }

    store.send(.increment) {
      $0.count = 1
    }
  }

  func testDecrement() {
    let store = TestStore(initialState: TrashDetailReducer.State()) {
      TrashDetailReducer()
    }

    store.send(.decrement) {
      $0.count = -1
    }
  }
}

