//
//  SearchAddressUseCaseKey.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 6/27/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum SearchAreaUseCaseKey: DependencyKey {
  public static var liveValue: SearchAreaUseCase { SearchAreaUseCaseProvider() }
  public static var previewValue: SearchAreaUseCase { SearchAreaUseCaseProvider() }
  public static var testValue: SearchAreaUseCase { SearchAreaUseCaseProvider() }
}

private var SearchAreaUseCaseProvider: () -> SearchAreaUseCase = {
  fatalError("UserUseCase Dependency not configured")
}

public func SearchAreaUseCaseRegister(
  provider: @escaping () -> SearchAreaUseCase
) {
  SearchAreaUseCaseProvider = provider
}

extension DependencyValues {
  public var SearchAreaUseCase: SearchAreaUseCase {
    get { self[SearchAreaUseCaseKey.self] }
    set { self[SearchAreaUseCaseKey.self] = newValue }
  }
}
