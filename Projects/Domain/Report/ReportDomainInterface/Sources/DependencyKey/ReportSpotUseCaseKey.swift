//
//  ReportDependencyKey.swift
//
//  ReportDomainInterface
//
//  Created by yongin
//

import Foundation
import Dependencies

public enum ReportSpotUseCaseKey: DependencyKey {
  public static var liveValue: ReportSpotUseCase { ReportSpotUseCaseProvider() }
  public static var previewValue: ReportSpotUseCase { ReportSpotUseCaseProvider() }
  public static var testValue: ReportSpotUseCase { ReportSpotUseCaseProvider() }
}

private var ReportSpotUseCaseProvider: () -> ReportSpotUseCase = {
  fatalError("ReportUseCase Dependency not configured")
}

public func ReportSpotUseCaseRegister(
  provider: @escaping () -> ReportSpotUseCase
) {
  ReportSpotUseCaseProvider = provider
}

extension DependencyValues {
  public var ReportSpotUseCase: ReportSpotUseCase {
    get { self[ReportSpotUseCaseKey.self] }
    set { self[ReportSpotUseCaseKey.self] = newValue }
  }
}
