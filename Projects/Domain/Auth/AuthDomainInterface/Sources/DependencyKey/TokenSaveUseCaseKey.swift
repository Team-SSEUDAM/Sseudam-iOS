//
//  TokenSaveUseCaseKey.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 6/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum TokenSaveUseCaseKey: DependencyKey {
  public static var liveValue: TokenSaveUseCase { TokenSaveUseCaseProvider() }
  public static var previewValue: TokenSaveUseCase { TokenSaveUseCaseProvider() }
  public static var testValue: TokenSaveUseCase { TokenSaveUseCaseProvider() }
}

private var TokenSaveUseCaseProvider: () -> TokenSaveUseCase = {
  fatalError("AuthUseCase Dependency not configured")
}

public func TokenSaveUseCaseRegister(
  provider: @escaping () -> TokenSaveUseCase
) {
  TokenSaveUseCaseProvider = provider
}

extension DependencyValues {
  public var TokenSaveUseCase: TokenSaveUseCase {
    get { self[TokenSaveUseCaseKey.self] }
    set { self[TokenSaveUseCaseKey.self] = newValue }
  }
}
