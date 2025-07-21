//
//  VisitedUseCaseTest.swift
//
//  VisitedDomainTesting
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import VisitedDomainInterface

final class VisitedUseCaseTests: XCTestCase {
  
  func testExecute() async throws {
    let repository = MockVisitedRepository()
    let useCase = VisitedUseCaseImpl(repository: repository)

    let result = try await useCase.execute()
    XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockVisitedRepository: VisitedRepository {
  func fetchData() async throws -> String {
    return "Mocked Data"
  }
}

