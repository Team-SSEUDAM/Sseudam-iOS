//
//  PetUseCaseTest.swift
//
//  PetDomainTesting
//
//  Created by yongin
//

import XCTest
import Dependencies
@testable import PetDomainInterface

final class PetUseCaseTests: XCTestCase {
  
  func testExecute() async throws {
    let repository = MockPetRepository()
    let useCase = PetUseCaseImpl(repository: repository)

    let result = try await useCase.execute()
    XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockPetRepository: PetRepository {
  func fetchData() async throws -> String {
    return "Mocked Data"
  }
}

