//
//  SampleRepository.swift
//
//  SampleDomainInterface
//
//  Created by JiYeon
//

import Foundation
import Dependencies

public enum SampleUseCaseKey: DependencyKey {
  public static var liveValue: SampleUseCase { SampleUseCaseProvider() }
  public static var previewValue: SampleUseCase { SampleUseCaseProvider() }
  public static var testValue: SampleUseCase { SampleUseCaseProvider() }
}

var SampleUseCaseProvider: () -> SampleUseCase = {
  fatalError("SampleUseCase Dependency not configured")
}

public func SampleUseCaseRegister(
  provider: @escaping () -> SampleUseCase
) {
  SampleUseCaseProvider = provider
}

extension DependencyValues {
  public var SampleUseCase: SampleUseCase {
    get { self[SampleUseCaseKey.self] }
    set { self[SampleUseCaseKey.self] = newValue }
  }
}
