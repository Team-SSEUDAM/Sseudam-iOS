//
//  AttendanceUseCaseTest.swift
//
//  AttendanceDomainTesting
//
//  Created by Jiyeon
//

import XCTest
import Dependencies
@testable import AttendanceDomainInterface

final class AttendanceUseCaseTests: XCTestCase {
  
  func testExecute() async throws {
    let repository = MockAttendanceRepository()
    let useCase = AttendanceUseCaseImpl(repository: repository)

    let result = try await useCase.execute()
    XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockAttendanceRepository: AttendanceRepository {
  func fetchData() async throws -> String {
    return "Mocked Data"
  }
}

