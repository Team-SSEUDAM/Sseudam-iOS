//
//  ImageDownloadUseCaseTest.swift
//
//  ImageDownloadDomainTesting
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import ImageDownloadDomainInterface

final class ImageDownloadUseCaseTests: XCTestCase {
  
  func testExecute() async throws {
    let repository = MockImageDownloadRepository()
    let useCase = ImageDownloadUseCaseImpl(repository: repository)

    let result = try await useCase.execute()
    XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockImageDownloadRepository: ImageDownloadRepository {
  func fetchData() async throws -> String {
    return "Mocked Data"
  }
}

