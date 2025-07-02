//
//  SpotNameValidateUseCaseKey.swift
//  SuggestionDomainInterface
//
//  Created by 조용인 on 6/30/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum SpotNameValidateUseCaseKey: DependencyKey {
  public static var liveValue: SpotNameValidateUseCase { SpotNameValidateUseCaseProvider() }
  public static var previewValue: SpotNameValidateUseCase { SpotNameValidateUseCaseProvider() }
  public static var testValue: SpotNameValidateUseCase { SpotNameValidateUseCaseProvider() }
}

private var SpotNameValidateUseCaseProvider: () -> SpotNameValidateUseCase = {
  fatalError("SuggestionUseCase Dependency not configured")
}

public func SpotNameValidateUseCaseRegister(
  provider: @escaping () -> SpotNameValidateUseCase
) {
  SpotNameValidateUseCaseProvider = provider
}

extension DependencyValues {
  public var SpotNameValidateUseCase: SpotNameValidateUseCase {
    get { self[SpotNameValidateUseCaseKey.self] }
    set { self[SpotNameValidateUseCaseKey.self] = newValue }
  }
}
