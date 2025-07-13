//
//  VisitedDependencyKey.swift
//
//  VisitedDomainInterface
//
//  Created by JiYeon
//

import Foundation
import Dependencies

public enum VisitedUseCaseKey: DependencyKey {
  public static var liveValue: VisitedUseCase { VisitedUseCaseProvider() }
  public static var previewValue: VisitedUseCase { VisitedUseCaseProvider() }
  public static var testValue: VisitedUseCase { VisitedUseCaseProvider() }
}

private var VisitedUseCaseProvider: () -> VisitedUseCase = {
  fatalError("VisitedUseCase Dependency not configured")
}

public func VisitedUseCaseRegister(
  provider: @escaping () -> VisitedUseCase
) {
  VisitedUseCaseProvider = provider
}

extension DependencyValues {
  public var VisitedUseCase: VisitedUseCase {
    get { self[VisitedUseCaseKey.self] }
    set { self[VisitedUseCaseKey.self] = newValue }
  }
}
