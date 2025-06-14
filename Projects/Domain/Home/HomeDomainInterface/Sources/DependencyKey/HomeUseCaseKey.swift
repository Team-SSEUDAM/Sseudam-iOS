//
//  HomeDependencyKey.swift
//
//  HomeDomainInterface
//
//  Created by JiYeon
//

import Foundation
import Dependencies

public enum HomeUseCaseKey: DependencyKey {
  public static var liveValue: HomeUseCase { HomeUseCaseProvider() }
  public static var previewValue: HomeUseCase { HomeUseCaseProvider() }
  public static var testValue: HomeUseCase { HomeUseCaseProvider() }
}

private var HomeUseCaseProvider: () -> HomeUseCase = {
  fatalError("HomeUseCase Dependency not configured")
}

public func HomeUseCaseRegister(
  provider: @escaping () -> HomeUseCase
) {
  HomeUseCaseProvider = provider
}

extension DependencyValues {
  public var HomeUseCase: HomeUseCase {
    get { self[HomeUseCaseKey.self] }
    set { self[HomeUseCaseKey.self] = newValue }
  }
}
