//
//  DeleteAddressUseCaseKey.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum DeleteAreaListUseCaseKey: DependencyKey {
  public static var liveValue: DeleteAreaListUseCase { DeleteAreaListUseCaseProvider() }
  public static var previewValue: DeleteAreaListUseCase { DeleteAreaListUseCaseProvider() }
  public static var testValue: DeleteAreaListUseCase { DeleteAreaListUseCaseProvider() }
}

private var DeleteAreaListUseCaseProvider: () -> DeleteAreaListUseCase = {
  fatalError("UserUseCase Dependency not configured")
}

public func DeleteAreaListUseCaseRegister(
  provider: @escaping () -> DeleteAreaListUseCase
) {
  DeleteAreaListUseCaseProvider = provider
}

extension DependencyValues {
  public var DeleteAreaListUseCase: DeleteAreaListUseCase {
    get { self[DeleteAreaListUseCaseKey.self] }
    set { self[DeleteAreaListUseCaseKey.self] = newValue }
  }
}
