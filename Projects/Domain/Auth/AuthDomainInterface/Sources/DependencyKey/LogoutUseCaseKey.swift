//
//  LogoutUseCaseKey.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 7/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum LogoutUseCaseKey: DependencyKey {
  public static var liveValue: LogoutUseCase { LogoutUseCaseProvider() }
  public static var previewValue: LogoutUseCase { LogoutUseCaseProvider() }
  public static var testValue: LogoutUseCase { LogoutUseCaseProvider() }
}

private var LogoutUseCaseProvider: () -> LogoutUseCase = {
  fatalError("LogoutUseCase Dependency not configured")
}

public func LogoutUseCaseRegister(
  provider: @escaping () -> LogoutUseCase
) {
  LogoutUseCaseProvider = provider
}

extension DependencyValues {
  public var LogoutUseCase: LogoutUseCase {
    get { self[LogoutUseCaseKey.self] }
    set { self[LogoutUseCaseKey.self] = newValue }
  }
}
