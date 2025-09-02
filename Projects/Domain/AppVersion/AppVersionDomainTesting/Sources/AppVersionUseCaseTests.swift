//
//  AppVersionUseCaseTest.swift
//
//  AppVersionDomainTesting
//
//  Created by yongin
//

import XCTest
import Dependencies
@testable import AppVersionDomainInterface

final class AppVersionUseCaseTests: XCTestCase {
  
  func testExecute() async throws {
    let repository = MockAppVersionRepository()
    let useCase = AppVersionUseCaseImpl(repository: repository)

    let result = try await useCase.execute()
    XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockAppVersionRepository: AppVersionRepository {
  func fetchData() async throws -> String {
    return "Mocked Data"
  }
}

