//
//  AttendanceDataTests.swift
//
//  Attendance
//
//  Created by Jiyeon
//

import XCTest
import Dependencies
@testable import AttendanceDataInterface
@testable import AttendanceDomainInterface
@testable import Core

extension MockNetworker: NetworkProtocol {
  func request<T: Decodable>(_ request: URLRequest) async throws -> T {
    return "Mocked API Data" as! T // Mock response
  }
}

final class AttendanceRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = AttendanceRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class AttendanceRepositoryImpl: AttendanceRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}

