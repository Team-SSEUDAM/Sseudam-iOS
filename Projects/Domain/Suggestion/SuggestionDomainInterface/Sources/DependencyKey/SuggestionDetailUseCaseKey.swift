//
//  SuggestionDetailUseCaseKey.swift
//  SuggestionDomainInterface
//
//  Created by Jiyeon on 10/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum SuggestionDetailUseCaseKey: DependencyKey {
  public static var liveValue: SuggestionDetailUseCase { SuggestionDetailUseCaseProvider() }
}

private var SuggestionDetailUseCaseProvider: () -> SuggestionDetailUseCase = {
  fatalError("SuggestionDetailUseCase Dependency not configured")
}

public func SuggestionDetailUseCaseRegister(
  provider: @escaping () -> SuggestionDetailUseCase
) {
  SuggestionDetailUseCaseProvider = provider
}

extension DependencyValues {
  public var SuggestionDetailUseCase: SuggestionDetailUseCase {
    get { self[SuggestionDetailUseCaseKey.self] }
    set { self[SuggestionDetailUseCaseKey.self] = newValue }
  }
}
