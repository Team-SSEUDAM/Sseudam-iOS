//
//  AppleLoginUseCaseKey.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies


public enum AppleLoginUseCaseKey: DependencyKey {
  public static var liveValue: AppleLoginUseCase { AppleLoginUseCaseProvider() }
  public static var previewValue: AppleLoginUseCase { AppleLoginUseCaseProvider() }
  public static var testValue: AppleLoginUseCase { AppleLoginUseCaseProvider() }
}

private var AppleLoginUseCaseProvider: () -> AppleLoginUseCase = {
  fatalError("AuthUseCase Dependency not configured")
}

public func AppleLoginUseCaseRegister(
  provider: @escaping () -> AppleLoginUseCase
) {
  AppleLoginUseCaseProvider = provider
}

extension DependencyValues {
  public var AppleLoginUseCase: AppleLoginUseCase {
    get { self[AppleLoginUseCaseKey.self] }
    set { self[AppleLoginUseCaseKey.self] = newValue }
  }
}
