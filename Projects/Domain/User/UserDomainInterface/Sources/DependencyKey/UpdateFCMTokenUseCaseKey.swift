//
//  UpdateFCMTokenUseCaseKey.swift
//  UserDomainInterface
//
//  Created by 조용인 on 10/8/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum UpdateFCMTokenUseCaseKey: DependencyKey {
  public static var liveValue: UpdateFCMTokenUseCase { UpdateFCMTokenUseCaseProvider() }
  public static var previewValue: UpdateFCMTokenUseCase { UpdateFCMTokenUseCaseProvider() }
  public static var testValue: UpdateFCMTokenUseCase { UpdateFCMTokenUseCaseProvider() }
}

private var UpdateFCMTokenUseCaseProvider: () -> UpdateFCMTokenUseCase = {
  fatalError("WithdrawalUseCase Dependency not configured")
}

public func UpdateFCMTokenUseCaseRegister(
  provider: @escaping () -> UpdateFCMTokenUseCase
) {
  UpdateFCMTokenUseCaseProvider = provider
}

extension DependencyValues {
  public var UpdateFCMTokenUseCase: UpdateFCMTokenUseCase {
    get { self[UpdateFCMTokenUseCaseKey.self] }
    set { self[UpdateFCMTokenUseCaseKey.self] = newValue }
  }
}

