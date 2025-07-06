//
//  TrashSpotUseCaseTest.swift
//
//  TrashSpotDomainTesting
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import TrashSpotDomainInterface

final class TrashSpotUseCaseTests: XCTestCase {
  
  func testExecute() async throws {
    let repository = MockTrashSpotRepository()
    let useCase = TrashSpotUseCaseImpl(repository: repository)

    let result = try await useCase.execute()
    XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockTrashSpotRepository: TrashSpotRepository {
  func fetchData() async throws -> String {
    return "Mocked Data"
  }
}

