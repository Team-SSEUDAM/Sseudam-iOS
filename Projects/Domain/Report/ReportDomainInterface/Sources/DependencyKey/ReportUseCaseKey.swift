//
//  ReportDependencyKey.swift
//
//  ReportDomainInterface
//
//  Created by yongin
//

import Foundation
import Dependencies

public enum ReportUseCaseKey: DependencyKey {
  public static var liveValue: ReportUseCase { ReportUseCaseProvider() }
  public static var previewValue: ReportUseCase { ReportUseCaseProvider() }
  public static var testValue: ReportUseCase { ReportUseCaseProvider() }
}

private var ReportUseCaseProvider: () -> ReportUseCase = {
  fatalError("ReportUseCase Dependency not configured")
}

public func ReportUseCaseRegister(
  provider: @escaping () -> ReportUseCase
) {
  ReportUseCaseProvider = provider
}

extension DependencyValues {
  public var ReportUseCase: ReportUseCase {
    get { self[ReportUseCaseKey.self] }
    set { self[ReportUseCaseKey.self] = newValue }
  }
}
