//
//  UserDependencyKey.swift
//
//  UserDomainInterface
//
//  Created by JiYeon
//

import Foundation
import Dependencies

public enum UserUseCaseKey: DependencyKey {
  public static var liveValue: UserUseCase { UserUseCaseProvider() }
  public static var previewValue: UserUseCase { UserUseCaseProvider() }
  public static var testValue: UserUseCase { UserUseCaseProvider() }
}

private var UserUseCaseProvider: () -> UserUseCase = {
  fatalError("UserUseCase Dependency not configured")
}

public func UserUseCaseRegister(
  provider: @escaping () -> UserUseCase
) {
  UserUseCaseProvider = provider
}

extension DependencyValues {
  public var UserUseCase: UserUseCase {
    get { self[UserUseCaseKey.self] }
    set { self[UserUseCaseKey.self] = newValue }
  }
}
