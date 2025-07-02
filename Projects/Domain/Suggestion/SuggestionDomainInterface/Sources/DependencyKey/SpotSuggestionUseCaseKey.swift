//
//  SpotSuggestionDependencyKey.swift
//
//  SuggestionDomainInterface
//
//  Created by yongin
//

import Foundation
import Dependencies

public enum SpotSuggestionUseCaseKey: DependencyKey {
  public static var liveValue: SpotSuggestionUseCase { SpotSuggestionUseCaseProvider() }
  public static var previewValue: SpotSuggestionUseCase { SpotSuggestionUseCaseProvider() }
  public static var testValue: SpotSuggestionUseCase { SpotSuggestionUseCaseProvider() }
}

private var SpotSuggestionUseCaseProvider: () -> SpotSuggestionUseCase = {
  fatalError("SuggestionUseCase Dependency not configured")
}

public func SpotSuggestionUseCaseRegister(
  provider: @escaping () -> SpotSuggestionUseCase
) {
  SpotSuggestionUseCaseProvider = provider
}

extension DependencyValues {
  public var SpotSuggestionUseCase: SpotSuggestionUseCase {
    get { self[SpotSuggestionUseCaseKey.self] }
    set { self[SpotSuggestionUseCaseKey.self] = newValue }
  }
}
