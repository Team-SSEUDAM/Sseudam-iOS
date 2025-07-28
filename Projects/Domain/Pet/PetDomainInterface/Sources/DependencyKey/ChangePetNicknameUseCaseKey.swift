//
//  ChangePetNicknameUseCaseKey.swift
//  PetDomainInterface
//
//  Created by 조용인 on 7/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum ChangePetNicknameUseCaseKey: DependencyKey {
  public static var liveValue: ChangePetNicknameUseCase { ChangePetNicknameUseCaseProvider() }
  public static var previewValue: ChangePetNicknameUseCase { ChangePetNicknameUseCaseProvider() }
  public static var testValue: ChangePetNicknameUseCase { ChangePetNicknameUseCaseProvider() }
}

private var ChangePetNicknameUseCaseProvider: () -> ChangePetNicknameUseCase = {
  fatalError("PetUseCase Dependency not configured")
}

public func ChangePetNicknameUseCaseRegister(
  provider: @escaping () -> ChangePetNicknameUseCase
) {
  ChangePetNicknameUseCaseProvider = provider
}

extension DependencyValues {
  public var ChangePetNicknameUseCase: ChangePetNicknameUseCase {
    get { self[ChangePetNicknameUseCaseKey.self] }
    set { self[ChangePetNicknameUseCaseKey.self] = newValue }
  }
}
