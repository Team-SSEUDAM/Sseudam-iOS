//
//  VisitedDataTests.swift
//
//  Visited
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import VisitedDataInterface
@testable import VisitedDomainInterface
@testable import Core

extension MockNetworker: NetworkProtocol {
  func request<T: Decodable>(_ request: URLRequest) async throws -> T {
    return "Mocked API Data" as! T // Mock response
  }
}

final class VisitedRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = VisitedRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class VisitedRepositoryImpl: VisitedRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}

