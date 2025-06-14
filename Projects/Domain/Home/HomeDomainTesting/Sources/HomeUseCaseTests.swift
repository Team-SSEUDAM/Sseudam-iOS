//
//  HomeUseCaseTest.swift
//
//  HomeDomainTesting
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import HomeDomainInterface

final class HomeUseCaseTests: XCTestCase {
  
  func testExecute() async throws {
    let repository = MockHomeRepository()
    let useCase = HomeUseCaseImpl(repository: repository)

    let result = try await useCase.execute()
    XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockHomeRepository: HomeRepository {
  func fetchData() async throws -> String {
    return "Mocked Data"
  }
}

