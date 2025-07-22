//
//  AttendanceDependencyKey.swift
//
//  AttendanceDomainInterface
//
//  Created by Jiyeon
//

import Foundation
import Dependencies

public enum AttendanceUseCaseKey: DependencyKey {
  public static var liveValue: AttendanceUseCase { AttendanceUseCaseProvider() }
  public static var previewValue: AttendanceUseCase { AttendanceUseCaseProvider() }
  public static var testValue: AttendanceUseCase { AttendanceUseCaseProvider() }
}

private var AttendanceUseCaseProvider: () -> AttendanceUseCase = {
  fatalError("AttendanceUseCase Dependency not configured")
}

public func AttendanceUseCaseRegister(
  provider: @escaping () -> AttendanceUseCase
) {
  AttendanceUseCaseProvider = provider
}

extension DependencyValues {
  public var AttendanceUseCase: AttendanceUseCase {
    get { self[AttendanceUseCaseKey.self] }
    set { self[AttendanceUseCaseKey.self] = newValue }
  }
}
