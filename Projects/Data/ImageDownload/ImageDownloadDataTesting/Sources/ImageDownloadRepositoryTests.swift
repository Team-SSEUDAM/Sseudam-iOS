//
//  ImageDownloadDataTests.swift
//
//  ImageDownload
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import ImageDownloadDataInterface
@testable import ImageDownloadDomainInterface
@testable import Core

extension MockNetworker: NetworkProtocol {
  func request<T: Decodable>(_ request: URLRequest) async throws -> T {
    return "Mocked API Data" as! T // Mock response
  }
}

final class ImageDownloadRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = ImageDownloadRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class ImageDownloadRepositoryImpl: ImageDownloadRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}

