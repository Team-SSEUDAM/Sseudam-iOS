//
//  ReportDataTests.swift
//
//  Report
//
//  Created by yongin
//

import XCTest
import Dependencies
@testable import ReportDataInterface
@testable import ReportDomainInterface
@testable import Core

extension MockNetworker: NetworkProtocol {
  func request<T: Decodable>(_ request: URLRequest) async throws -> T {
    return "Mocked API Data" as! T // Mock response
  }
}

final class ReportRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = ReportRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class ReportRepositoryImpl: ReportRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}

