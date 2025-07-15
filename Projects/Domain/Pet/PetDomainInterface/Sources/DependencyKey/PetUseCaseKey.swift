//
//  PetDependencyKey.swift
//
//  PetDomainInterface
//
//  Created by yongin
//

import Foundation
import Dependencies

public enum PetUseCaseKey: DependencyKey {
  public static var liveValue: PetUseCase { PetUseCaseProvider() }
  public static var previewValue: PetUseCase { PetUseCaseProvider() }
  public static var testValue: PetUseCase { PetUseCaseProvider() }
}

private var PetUseCaseProvider: () -> PetUseCase = {
  fatalError("PetUseCase Dependency not configured")
}

public func PetUseCaseRegister(
  provider: @escaping () -> PetUseCase
) {
  PetUseCaseProvider = provider
}

extension DependencyValues {
  public var PetUseCase: PetUseCase {
    get { self[PetUseCaseKey.self] }
    set { self[PetUseCaseKey.self] = newValue }
  }
}
