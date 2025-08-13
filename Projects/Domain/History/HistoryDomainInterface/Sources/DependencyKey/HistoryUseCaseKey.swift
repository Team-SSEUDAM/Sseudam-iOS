//
//  HistoryDependencyKey.swift
//
//  HistoryDomainInterface
//
//  Created by yongin
//

import Foundation
import Dependencies

public enum GetSuggestionAndHistoryUseCaseKey: DependencyKey {
  public static var liveValue: GetSuggestionAndHistoryUseCase { GetSuggestionAndHistoryUseCaseProvider() }
  public static var previewValue: GetSuggestionAndHistoryUseCase { GetSuggestionAndHistoryUseCaseProvider() }
  public static var testValue: GetSuggestionAndHistoryUseCase { GetSuggestionAndHistoryUseCaseProvider() }
}

private var GetSuggestionAndHistoryUseCaseProvider: () -> GetSuggestionAndHistoryUseCase = {
  fatalError("GetSuggestionAndHistoryUseCase Dependency not configured")
}

public func GetSuggestionAndHistoryUseCaseRegister(
  provider: @escaping () -> GetSuggestionAndHistoryUseCase
) {
  GetSuggestionAndHistoryUseCaseProvider = provider
}

extension DependencyValues {
  public var GetSuggestionAndHistoryUseCase: GetSuggestionAndHistoryUseCase {
    get { self[GetSuggestionAndHistoryUseCaseKey.self] }
    set { self[GetSuggestionAndHistoryUseCaseKey.self] = newValue }
  }
}
