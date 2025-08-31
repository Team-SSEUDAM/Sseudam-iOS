//
//  AppVersionDependencyKey.swift
//
//  AppVersionDomainInterface
//
//  Created by yongin
//

import Foundation
import Dependencies

public enum CheckAppVersionUseCaseKey: DependencyKey {
  public static var liveValue: CheckAppVersionUseCase { CheckAppVersionUseCaseProvider() }
  public static var previewValue: CheckAppVersionUseCase { CheckAppVersionUseCaseProvider() }
  public static var testValue: CheckAppVersionUseCase { CheckAppVersionUseCaseProvider() }
}

private var CheckAppVersionUseCaseProvider: () -> CheckAppVersionUseCase = {
  fatalError("AppVersionUseCase Dependency not configured")
}

public func CheckAppVersionUseCaseRegister(
  provider: @escaping () -> CheckAppVersionUseCase
) {
  CheckAppVersionUseCaseProvider = provider
}

extension DependencyValues {
  public var CheckAppVersionUseCase: CheckAppVersionUseCase {
    get { self[CheckAppVersionUseCaseKey.self] }
    set { self[CheckAppVersionUseCaseKey.self] = newValue }
  }
}
