//
//  WithdrawalUseCaseKey.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 7/13/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum WithdrawalUseCaseKey: DependencyKey {
  public static var liveValue: WithdrawalUseCase { WithdrawalUseCaseProvider() }
  public static var previewValue: WithdrawalUseCase { WithdrawalUseCaseProvider() }
  public static var testValue: WithdrawalUseCase { WithdrawalUseCaseProvider() }
}

private var WithdrawalUseCaseProvider: () -> WithdrawalUseCase = {
  fatalError("WithdrawalUseCase Dependency not configured")
}

public func WithdrawalUseCaseRegister(
  provider: @escaping () -> WithdrawalUseCase
) {
  WithdrawalUseCaseProvider = provider
}

extension DependencyValues {
  public var WithdrawalUseCase: WithdrawalUseCase {
    get { self[WithdrawalUseCaseKey.self] }
    set { self[WithdrawalUseCaseKey.self] = newValue }
  }
}

