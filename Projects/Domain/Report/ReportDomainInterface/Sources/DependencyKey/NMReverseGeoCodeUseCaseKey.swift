//
//  NMReverseGeoCodeUseCaseKey.swift
//  ReportDomainInterface
//
//  Created by 조용인 on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum NMReverseGeoCodeUseCaseKey: DependencyKey {
  public static var liveValue: NMReverseGeoCodeUseCase { NMReverseGeoCodeUseCaseProvider() }
  public static var previewValue: NMReverseGeoCodeUseCase { NMReverseGeoCodeUseCaseProvider() }
  public static var testValue: NMReverseGeoCodeUseCase { NMReverseGeoCodeUseCaseProvider() }
}

private var NMReverseGeoCodeUseCaseProvider: () -> NMReverseGeoCodeUseCase = {
  fatalError("ReportUseCase Dependency not configured")
}

public func NMReverseGeoCodeUseCaseRegister(
  provider: @escaping () -> NMReverseGeoCodeUseCase
) {
  NMReverseGeoCodeUseCaseProvider = provider
}

extension DependencyValues {
  public var NMReverseGeoCodeUseCase: NMReverseGeoCodeUseCase {
    get { self[NMReverseGeoCodeUseCaseKey.self] }
    set { self[NMReverseGeoCodeUseCaseKey.self] = newValue }
  }
}
