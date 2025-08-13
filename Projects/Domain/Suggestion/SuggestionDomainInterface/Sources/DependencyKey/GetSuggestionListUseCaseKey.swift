//
//  GetSuggestionListUseCaseKey.swift
//  SuggestionDomainInterface
//
//  Created by 조용인 on 8/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum GetSuggestionListUseCaseKey: DependencyKey {
  public static var liveValue: GetSuggestionListUseCase { GetSuggestionListUseCaseProvider() }
  public static var previewValue: GetSuggestionListUseCase { GetSuggestionListUseCaseProvider() }
  public static var testValue: GetSuggestionListUseCase { GetSuggestionListUseCaseProvider() }
}

private var GetSuggestionListUseCaseProvider: () -> GetSuggestionListUseCase = {
  fatalError("SuggestionUseCase Dependency not configured")
}

public func GetSuggestionListUseCaseRegister(
  provider: @escaping () -> GetSuggestionListUseCase
) {
  GetSuggestionListUseCaseProvider = provider
}

extension DependencyValues {
  public var GetSuggestionListUseCase: GetSuggestionListUseCase {
    get { self[GetSuggestionListUseCaseKey.self] }
    set { self[GetSuggestionListUseCaseKey.self] = newValue }
  }
}
