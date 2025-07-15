//
//  PetDataTests.swift
//
//  Pet
//
//  Created by yongin
//

import XCTest
import Dependencies
@testable import PetDataInterface
@testable import PetDomainInterface
@testable import Core

extension MockNetworker: NetworkProtocol {
  func request<T: Decodable>(_ request: URLRequest) async throws -> T {
    return "Mocked API Data" as! T // Mock response
  }
}

final class PetRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = PetRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class PetRepositoryImpl: PetRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}

