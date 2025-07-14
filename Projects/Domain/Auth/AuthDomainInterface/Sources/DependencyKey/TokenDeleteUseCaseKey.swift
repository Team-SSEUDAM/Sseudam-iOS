//
//  TokenDeleteUseCaseKey.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 7/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum TokenDeleteUseCaseKey: DependencyKey {
  public static var liveValue: TokenDeleteUseCase { TokenDeleteUseCaseProvider() }
  public static var previewValue: TokenDeleteUseCase { TokenDeleteUseCaseProvider() }
  public static var testValue: TokenDeleteUseCase { TokenDeleteUseCaseProvider() }
}

private var TokenDeleteUseCaseProvider: () -> TokenDeleteUseCase = {
  fatalError("TokenDeleteUseCase Dependency not configured")
}

public func TokenDeleteUseCaseRegister(
  provider: @escaping () -> TokenDeleteUseCase
) {
  TokenDeleteUseCaseProvider = provider
}

extension DependencyValues {
  public var TokenDeleteUseCase: TokenDeleteUseCase {
    get { self[TokenDeleteUseCaseKey.self] }
    set { self[TokenDeleteUseCaseKey.self] = newValue }
  }
}
