//
//  NotificationUseCaseTest.swift
//
//  NotificationDomainTesting
//
//  Created by Jiyeon
//

import XCTest
import Dependencies
@testable import NotificationDomainInterface

final class NotificationUseCaseTests: XCTestCase {
  
  func testExecute() async throws {
    let repository = MockNotificationRepository()
    let useCase = NotificationUseCaseImpl(repository: repository)

    let result = try await useCase.execute()
    XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockNotificationRepository: NotificationRepository {
  func fetchData() async throws -> String {
    return "Mocked Data"
  }
}

