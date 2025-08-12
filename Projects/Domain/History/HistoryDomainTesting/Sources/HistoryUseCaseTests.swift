//
//  HistoryUseCaseTest.swift
//
//  HistoryDomainTesting
//
//  Created by yongin
//

import XCTest
import Dependencies
@testable import HistoryDomainInterface

final class HistoryUseCaseTests: XCTestCase {
  
  func testExecute() async throws {
    let repository = MockHistoryRepository()
    let useCase = HistoryUseCaseImpl(repository: repository)

    let result = try await useCase.execute()
    XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockHistoryRepository: HistoryRepository {
  func fetchData() async throws -> String {
    return "Mocked Data"
  }
}

