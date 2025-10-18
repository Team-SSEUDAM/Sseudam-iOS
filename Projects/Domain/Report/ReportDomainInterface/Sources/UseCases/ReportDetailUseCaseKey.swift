//
//  ReportDetailUseCaseKey.swift
//  ReportDomainInterface
//
//  Created by Jiyeon on 10/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum ReportDetailUseCaseKey: DependencyKey {
  public static var liveValue: ReportDetailUseCase { ReportDetailUseCaseKeyProvider() }
  public static var previewValue: ReportDetailUseCase { ReportDetailUseCaseKeyProvider() }
  public static var testValue: ReportDetailUseCase { ReportDetailUseCaseKeyProvider() }
}

private var ReportDetailUseCaseKeyProvider: () -> ReportDetailUseCase = {
  fatalError("ReportDetailUseCase Dependency not configured")
}

public func ReportDetailUseCaseRegister(
  provider: @escaping () -> ReportDetailUseCase
) {
  ReportDetailUseCaseKeyProvider = provider
}

extension DependencyValues {
  public var ReportDetailUseCase: ReportDetailUseCase {
    get { self[ReportDetailUseCaseKey.self] }
    set { self[ReportDetailUseCaseKey.self] = newValue }
  }
}
// ReportDetailUseCase
