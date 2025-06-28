//
//  LoadAddressListUseCaseKey.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 6/27/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum LoadAreaListUseCaseKey: DependencyKey {
  public static var liveValue: LoadAreaListUseCase { LoadAreaListUseCaseProvider() }
  public static var previewValue: LoadAreaListUseCase { LoadAreaListUseCaseProvider() }
  public static var testValue: LoadAreaListUseCase { LoadAreaListUseCaseProvider() }
}

private var LoadAreaListUseCaseProvider: () -> LoadAreaListUseCase = {
  fatalError("UserUseCase Dependency not configured")
}

public func LoadAreaListUseCaseRegister(
  provider: @escaping () -> LoadAreaListUseCase
) {
  LoadAreaListUseCaseProvider = provider
}

extension DependencyValues {
  public var LoadAreaListUseCase: LoadAreaListUseCase {
    get { self[LoadAreaListUseCaseKey.self] }
    set { self[LoadAreaListUseCaseKey.self] = newValue }
  }
}
