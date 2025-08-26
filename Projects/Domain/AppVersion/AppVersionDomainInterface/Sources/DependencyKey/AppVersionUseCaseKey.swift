//
//  AppVersionDependencyKey.swift
//
//  AppVersionDomainInterface
//
//  Created by yongin
//

import Foundation
import Dependencies

public enum AppVersionUseCaseKey: DependencyKey {
  public static var liveValue: AppVersionUseCase { AppVersionUseCaseProvider() }
  public static var previewValue: AppVersionUseCase { AppVersionUseCaseProvider() }
  public static var testValue: AppVersionUseCase { AppVersionUseCaseProvider() }
}

private var AppVersionUseCaseProvider: () -> AppVersionUseCase = {
  fatalError("AppVersionUseCase Dependency not configured")
}

public func AppVersionUseCaseRegister(
  provider: @escaping () -> AppVersionUseCase
) {
  AppVersionUseCaseProvider = provider
}

extension DependencyValues {
  public var AppVersionUseCase: AppVersionUseCase {
    get { self[AppVersionUseCaseKey.self] }
    set { self[AppVersionUseCaseKey.self] = newValue }
  }
}
