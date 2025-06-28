//
//  SuggestionDependencyKey.swift
//
//  SuggestionDomainInterface
//
//  Created by yongin
//

import Foundation
import Dependencies

public enum SuggestionUseCaseKey: DependencyKey {
  public static var liveValue: SuggestionUseCase { SuggestionUseCaseProvider() }
  public static var previewValue: SuggestionUseCase { SuggestionUseCaseProvider() }
  public static var testValue: SuggestionUseCase { SuggestionUseCaseProvider() }
}

private var SuggestionUseCaseProvider: () -> SuggestionUseCase = {
  fatalError("SuggestionUseCase Dependency not configured")
}

public func SuggestionUseCaseRegister(
  provider: @escaping () -> SuggestionUseCase
) {
  SuggestionUseCaseProvider = provider
}

extension DependencyValues {
  public var SuggestionUseCase: SuggestionUseCase {
    get { self[SuggestionUseCaseKey.self] }
    set { self[SuggestionUseCaseKey.self] = newValue }
  }
}
