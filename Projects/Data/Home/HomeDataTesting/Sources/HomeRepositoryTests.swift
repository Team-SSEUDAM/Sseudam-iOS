//
//  HomeDataTests.swift
//
//  Home
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import HomeDataInterface
@testable import HomeDomainInterface
@testable import Core

extension MockNetworker: NetworkProtocol {
  func request<T: Decodable>(_ request: URLRequest) async throws -> T {
    return "Mocked API Data" as! T // Mock response
  }
}

final class HomeRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = HomeRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class HomeRepositoryImpl: HomeRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}

