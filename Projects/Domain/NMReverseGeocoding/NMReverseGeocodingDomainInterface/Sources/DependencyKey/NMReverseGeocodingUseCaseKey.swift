//
//  NMReverseGeocodingDependencyKey.swift
//
//  NMReverseGeocodingDomainInterface
//
//  Created by yongin
//

import Foundation
import Dependencies

public enum NMReverseGeocodingUseCaseKey: DependencyKey {
  public static var liveValue: NMReverseGeocodingUseCase { NMReverseGeocodingUseCaseProvider() }
  public static var previewValue: NMReverseGeocodingUseCase { NMReverseGeocodingUseCaseProvider() }
  public static var testValue: NMReverseGeocodingUseCase { NMReverseGeocodingUseCaseProvider() }
}

private var NMReverseGeocodingUseCaseProvider: () -> NMReverseGeocodingUseCase = {
  fatalError("NMReverseGeocodingUseCase Dependency not configured")
}

public func NMReverseGeocodingUseCaseRegister(
  provider: @escaping () -> NMReverseGeocodingUseCase
) {
  NMReverseGeocodingUseCaseProvider = provider
}

extension DependencyValues {
  public var NMReverseGeocodingUseCase: NMReverseGeocodingUseCase {
    get { self[NMReverseGeocodingUseCaseKey.self] }
    set { self[NMReverseGeocodingUseCaseKey.self] = newValue }
  }
}
