//
//  AppVersionDataTests.swift
//
//  AppVersion
//
//  Created by yongin
//

import XCTest
import Dependencies
@testable import AppVersionDataInterface
@testable import AppVersionDomainInterface
@testable import Core

extension MockNetworker: NetworkProtocol {
  func request<T: Decodable>(_ request: URLRequest) async throws -> T {
    return "Mocked API Data" as! T // Mock response
  }
}

final class AppVersionRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = AppVersionRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class AppVersionRepositoryImpl: AppVersionRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}

