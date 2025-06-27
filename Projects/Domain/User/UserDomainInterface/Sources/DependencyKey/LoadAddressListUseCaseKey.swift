//
//  LoadAddressListUseCaseKey.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 6/27/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum LoadAddressListUseCaseKey: DependencyKey {
  public static var liveValue: LoadAddressListUseCase { LoadAddressListUseCaseProvider() }
  public static var previewValue: LoadAddressListUseCase { LoadAddressListUseCaseProvider() }
  public static var testValue: LoadAddressListUseCase { LoadAddressListUseCaseProvider() }
}

private var LoadAddressListUseCaseProvider: () -> LoadAddressListUseCase = {
  fatalError("UserUseCase Dependency not configured")
}

public func LoadAddressListUseCaseRegister(
  provider: @escaping () -> LoadAddressListUseCase
) {
  LoadAddressListUseCaseProvider = provider
}

extension DependencyValues {
  public var LoadAddressListUseCase: LoadAddressListUseCase {
    get { self[LoadAddressListUseCaseKey.self] }
    set { self[LoadAddressListUseCaseKey.self] = newValue }
  }
}
