//
//  ReportXCTest.swift
//
//  Report
//
//  Created by yongin
//

import Testing
import ComposableArchitecture

@testable import Report

@MainActor
struct ReportFeatureTest {
  @Test
  func addTest() async {
    let store = TestStore(
      initialState: ReportFeature.State(),
      reducer: { ReportFeature() }
    )
    
    await store.send(\.addButtonTapped) {
      $0.count += 1
    }
  }
  
}

