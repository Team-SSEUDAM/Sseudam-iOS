//
//  TrashSpotDataTests.swift
//
//  TrashSpot
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import TrashSpotDataInterface
@testable import TrashSpotDomainInterface
@testable import Core

extension MockNetworker: NetworkProtocol {
  func request<T: Decodable>(_ request: URLRequest) async throws -> T {
    return "Mocked API Data" as! T // Mock response
  }
}

final class TrashSpotRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = TrashSpotRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class TrashSpotRepositoryImpl: TrashSpotRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}

