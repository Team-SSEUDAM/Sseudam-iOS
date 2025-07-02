//
//  SuggestionDataTests.swift
//
//  Suggestion
//
//  Created by yongin
//

import XCTest
import Dependencies
@testable import SuggestionDataInterface
@testable import SuggestionDomainInterface
@testable import Core

extension MockNetworker: NetworkProtocol {
  func request<T: Decodable>(_ request: URLRequest) async throws -> T {
    return "Mocked API Data" as! T // Mock response
  }
}

final class SuggestionRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = SuggestionRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class SuggestionRepositoryImpl: SuggestionRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}

