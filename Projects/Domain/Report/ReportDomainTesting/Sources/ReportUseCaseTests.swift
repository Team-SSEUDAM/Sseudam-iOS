//
//  ReportUseCaseTest.swift
//
//  ReportDomainTesting
//
//  Created by yongin
//

import XCTest
import Dependencies
@testable import ReportDomainInterface

final class ReportUseCaseTests: XCTestCase {
  
  func testExecute() async throws {
    let repository = MockReportRepository()
    let useCase = ReportUseCaseImpl(repository: repository)

    let result = try await useCase.execute()
    XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockReportRepository: ReportRepository {
  func fetchData() async throws -> String {
    return "Mocked Data"
  }
}

