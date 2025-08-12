//
//  ChangeNicknameUseCaseKey.swift
//  UserDomainInterface
//
//  Created by 조용인 on 8/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum ChangeNicknameUseCaseKey: DependencyKey {
  public static var liveValue: ChangeNicknameUseCase { ChangeNicknameUseCaseProvider() }
  public static var previewValue: ChangeNicknameUseCase { ChangeNicknameUseCaseProvider() }
  public static var testValue: ChangeNicknameUseCase { ChangeNicknameUseCaseProvider() }
}

private var ChangeNicknameUseCaseProvider: () -> ChangeNicknameUseCase = {
  fatalError("UserUseCase Dependency not configured")
}


public func ChangeNicknameUseCaseRegister(
  provider: @escaping () -> ChangeNicknameUseCase
) {
  ChangeNicknameUseCaseProvider = provider
}

extension DependencyValues {
  public var ChangeNicknameUseCase: ChangeNicknameUseCase {
    get { self[ChangeNicknameUseCaseKey.self] }
    set { self[ChangeNicknameUseCaseKey.self] = newValue }
  }
}

