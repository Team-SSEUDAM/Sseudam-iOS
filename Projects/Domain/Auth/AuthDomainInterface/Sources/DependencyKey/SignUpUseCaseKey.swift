//
//  SignUpUseCaseKey.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum SignUpUseCaseKey: DependencyKey {
  public static var liveValue: SignUpUseCase { SignUpUseCaseProvider() }
  public static var previewValue: SignUpUseCase { SignUpUseCaseProvider() }
  public static var testValue: SignUpUseCase { SignUpUseCaseProvider() }
}

private var SignUpUseCaseProvider: () -> SignUpUseCase = {
  fatalError("SignUpUseCase Dependency not configured")
}

public func SignUpUseCaseRegister(
  provider: @escaping () -> SignUpUseCase
) {
  SignUpUseCaseProvider = provider
}

extension DependencyValues {
  public var SignUpUseCase: SignUpUseCase {
    get { self[SignUpUseCaseKey.self] }
    set { self[SignUpUseCaseKey.self] = newValue }
  }
}
