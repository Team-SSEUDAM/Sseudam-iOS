//
//  NMReverseGeocodingDataTests.swift
//
//  NMReverseGeocoding
//
//  Created by yongin
//

import XCTest
import Dependencies
@testable import NMReverseGeocodingDataInterface
@testable import NMReverseGeocodingDomainInterface
@testable import Core

extension MockNetworker: NetworkProtocol {
  func request<T: Decodable>(_ request: URLRequest) async throws -> T {
    return "Mocked API Data" as! T // Mock response
  }
}

final class NMReverseGeocodingRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = NMReverseGeocodingRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class NMReverseGeocodingRepositoryImpl: NMReverseGeocodingRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}

