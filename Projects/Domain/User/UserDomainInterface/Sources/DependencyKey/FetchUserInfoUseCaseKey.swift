//
//  FetchUserInfoUseCaseKey.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 7/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies


public enum FetchUserInfoUseCaseKey: DependencyKey {
  public static var liveValue: FetchUserInfoUseCase { FetchUserInfoUseCaseProvider() }
  public static var previewValue: FetchUserInfoUseCase { FetchUserInfoUseCaseProvider() }
  public static var testValue: FetchUserInfoUseCase { FetchUserInfoUseCaseProvider() }
}

private var FetchUserInfoUseCaseProvider: () -> FetchUserInfoUseCase = {
  fatalError("UserUseCase Dependency not configured")
}


public func FetchUserInfoUseCaseRegister(
  provider: @escaping () -> FetchUserInfoUseCase
) {
  FetchUserInfoUseCaseProvider = provider
}

extension DependencyValues {
  public var FetchUserInfoUseCase: FetchUserInfoUseCase {
    get { self[FetchUserInfoUseCaseKey.self] }
    set { self[FetchUserInfoUseCaseKey.self] = newValue }
  }
}

