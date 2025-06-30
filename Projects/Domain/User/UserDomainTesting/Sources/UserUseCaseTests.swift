//
//  UserUseCaseTest.swift
//
//  UserDomainTesting
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import UserDomainInterface

final class UserUseCaseTests: XCTestCase {
  
  func testExecute() async throws {
    let repository = MockUserRepository()
    let useCase = UserUseCaseImpl(repository: repository)

    let result = try await useCase.execute()
    XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockUserRepository: UserRepository {
  func fetchData() async throws -> String {
    return "Mocked Data"
  }
}

