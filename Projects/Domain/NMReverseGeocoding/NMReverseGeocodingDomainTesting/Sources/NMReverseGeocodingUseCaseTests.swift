//
//  NMReverseGeocodingUseCaseTest.swift
//
//  NMReverseGeocodingDomainTesting
//
//  Created by yongin
//

import XCTest
import Dependencies
@testable import NMReverseGeocodingDomainInterface

final class NMReverseGeocodingUseCaseTests: XCTestCase {
  
  func testExecute() async throws {
    let repository = MockNMReverseGeocodingRepository()
    let useCase = NMReverseGeocodingUseCaseImpl(repository: repository)

    let result = try await useCase.execute()
    XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockNMReverseGeocodingRepository: NMReverseGeocodingRepository {
  func fetchData() async throws -> String {
    return "Mocked Data"
  }
}

