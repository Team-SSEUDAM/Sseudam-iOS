//
//  NMReverseGeoCodeUseCaseKey.swift
//
//  NMReverseGeocodingDomainInterface
//
//  Created by yongin
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
