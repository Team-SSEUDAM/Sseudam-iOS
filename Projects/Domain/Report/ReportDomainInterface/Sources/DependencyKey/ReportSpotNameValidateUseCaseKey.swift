//
//  ReportSpotNameValidateUseCaseKey.swift
//  ReportDomainInterface
//
//  Created by 조용인 on 7/7/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum ReportSpotNameValidateUseCaseKey: DependencyKey {
  public static var liveValue: ReportSpotNameValidateUseCase { ReportSpotNameValidateUseCaseKeyProvider() }
  public static var previewValue: ReportSpotNameValidateUseCase { ReportSpotNameValidateUseCaseKeyProvider() }
  public static var testValue: ReportSpotNameValidateUseCase { ReportSpotNameValidateUseCaseKeyProvider() }
}

private var ReportSpotNameValidateUseCaseKeyProvider: () -> ReportSpotNameValidateUseCase = {
  fatalError("SuggestionUseCase Dependency not configured")
}

public func ReportSpotNameValidateUseCaseRegister(
  provider: @escaping () -> ReportSpotNameValidateUseCase
) {
  ReportSpotNameValidateUseCaseKeyProvider = provider
}

extension DependencyValues {
  public var SpotSuggestionUseCase: ReportSpotNameValidateUseCase {
    get { self[ReportSpotNameValidateUseCaseKey.self] }
    set { self[ReportSpotNameValidateUseCaseKey.self] = newValue }
  }
}
