//
//  NotificationDataTests.swift
//
//  Notification
//
//  Created by Jiyeon
//

import XCTest
import Dependencies
@testable import NotificationDataInterface
@testable import NotificationDomainInterface
@testable import Core

extension MockNetworker: NetworkProtocol {
  func request<T: Decodable>(_ request: URLRequest) async throws -> T {
    return "Mocked API Data" as! T // Mock response
  }
}

final class NotificationRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = NotificationRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class NotificationRepositoryImpl: NotificationRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}

