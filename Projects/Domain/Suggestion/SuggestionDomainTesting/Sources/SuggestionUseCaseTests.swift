//
//  SuggestionUseCaseTest.swift
//
//  SuggestionDomainTesting
//
//  Created by yongin
//

import XCTest
import Dependencies
@testable import SuggestionDomainInterface

final class SuggestionUseCaseTests: XCTestCase {
  
  func testExecute() async throws {
    let repository = MockSuggestionRepository()
    let useCase = SuggestionUseCaseImpl(repository: repository)

    let result = try await useCase.execute()
    XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockSuggestionRepository: SuggestionRepository {
  func fetchData() async throws -> String {
    return "Mocked Data"
  }
}

