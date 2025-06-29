//
//  CheckNicknameValidUseCaseKey.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 6/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum CheckNicknameValidUseCaseKey: DependencyKey {
  public static var liveValue: CheckNicknameValidateUseCase { CheckNicknameValidUseCaseProvider() }
  public static var previewValue: CheckNicknameValidateUseCase { CheckNicknameValidUseCaseProvider() }
  public static var testValue: CheckNicknameValidateUseCase { CheckNicknameValidUseCaseProvider() }
}

private var CheckNicknameValidUseCaseProvider: () -> CheckNicknameValidateUseCase = {
  fatalError("UserUseCase Dependency not configured")
}


public func CheckNicknameValidUseCaseRegister(
  provider: @escaping () -> CheckNicknameValidateUseCase
) {
  CheckNicknameValidUseCaseProvider = provider
}

extension DependencyValues {
  public var CheckNicknameValidateUseCase: CheckNicknameValidateUseCase {
    get { self[CheckNicknameValidUseCaseKey.self] }
    set { self[CheckNicknameValidUseCaseKey.self] = newValue }
  }
}

