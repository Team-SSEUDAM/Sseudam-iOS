//
//  UploadReportSpotImageUseCaseKey.swift
//  ReportDomainInterface
//
//  Created by 조용인 on 7/7/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum UploadReportSpotImageUseCaseKey: DependencyKey {
  public static var liveValue: UploadReportSpotImageUseCase { UploadReportSpotImageUseCaseProvider() }
  public static var previewValue: UploadReportSpotImageUseCase { UploadReportSpotImageUseCaseProvider() }
  public static var testValue: UploadReportSpotImageUseCase { UploadReportSpotImageUseCaseProvider() }
}

private var UploadReportSpotImageUseCaseProvider: () -> UploadReportSpotImageUseCase = {
  fatalError("SuggestionUseCase Dependency not configured")
}

public func UploadReportSpotImageUseCaseRegister(
  provider: @escaping () -> UploadReportSpotImageUseCase
) {
  UploadReportSpotImageUseCaseProvider = provider
}

extension DependencyValues {
  public var UploadReportSpotImageUseCase: UploadReportSpotImageUseCase {
    get { self[UploadReportSpotImageUseCaseKey.self] }
    set { self[UploadReportSpotImageUseCaseKey.self] = newValue }
  }
}
