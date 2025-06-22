//
//  AuthDependencyKey.swift
//
//  AuthDomainInterface
//
//  Created by JiYeon
//

import Foundation
import Dependencies

public enum AuthUseCaseKey: DependencyKey {
  public static var liveValue: AuthUseCase { AuthUseCaseProvider() }
  public static var previewValue: AuthUseCase { AuthUseCaseProvider() }
  public static var testValue: AuthUseCase { AuthUseCaseProvider() }
}

private var AuthUseCaseProvider: () -> AuthUseCase = {
  fatalError("AuthUseCase Dependency not configured")
}

public func AuthUseCaseRegister(
  provider: @escaping () -> AuthUseCase
) {
  AuthUseCaseProvider = provider
}

extension DependencyValues {
  public var AuthUseCase: AuthUseCase {
    get { self[AuthUseCaseKey.self] }
    set { self[AuthUseCaseKey.self] = newValue }
  }
}
