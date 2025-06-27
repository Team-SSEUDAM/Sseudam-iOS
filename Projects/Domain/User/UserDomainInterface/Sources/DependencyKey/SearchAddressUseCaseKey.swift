//
//  SearchAddressUseCaseKey.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 6/27/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum SearchAddressUseCaseKey: DependencyKey {
  public static var liveValue: SearchAddressUseCase { SearchAddressUseCaseProvider() }
  public static var previewValue: SearchAddressUseCase { SearchAddressUseCaseProvider() }
  public static var testValue: SearchAddressUseCase { SearchAddressUseCaseProvider() }
}

private var SearchAddressUseCaseProvider: () -> SearchAddressUseCase = {
  fatalError("UserUseCase Dependency not configured")
}

public func SearchAddressUseCaseRegister(
  provider: @escaping () -> SearchAddressUseCase
) {
  SearchAddressUseCaseProvider = provider
}

extension DependencyValues {
  public var SearchAddressUseCase: SearchAddressUseCase {
    get { self[SearchAddressUseCaseKey.self] }
    set { self[SearchAddressUseCaseKey.self] = newValue }
  }
}
