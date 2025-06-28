//
//  DeleteAddressUseCaseKey.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum DeleteAddressUseCaseKey: DependencyKey {
  public static var liveValue: DeleteAddressListUseCase { DeleteAddressListUseCaseProvider() }
  public static var previewValue: DeleteAddressListUseCase { DeleteAddressListUseCaseProvider() }
  public static var testValue: DeleteAddressListUseCase { DeleteAddressListUseCaseProvider() }
}

private var DeleteAddressListUseCaseProvider: () -> DeleteAddressListUseCase = {
  fatalError("UserUseCase Dependency not configured")
}

public func DeleteAddressListUseCaseRegister(
  provider: @escaping () -> DeleteAddressListUseCase
) {
  DeleteAddressListUseCaseProvider = provider
}

extension DependencyValues {
  public var DeleteAddressListUseCase: DeleteAddressListUseCase {
    get { self[DeleteAddressUseCaseKey.self] }
    set { self[DeleteAddressUseCaseKey.self] = newValue }
  }
}
