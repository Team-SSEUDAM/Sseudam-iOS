//
//  PetDependencyKey.swift
//
//  PetDomainInterface
//
//  Created by yongin
//

import Foundation
import Dependencies

public enum CheckPetInfoUseCaseKey: DependencyKey {
  public static var liveValue: CheckPetInfoUseCase { CheckPetInfoUseCaseProvider() }
  public static var previewValue: CheckPetInfoUseCase { CheckPetInfoUseCaseProvider() }
  public static var testValue: CheckPetInfoUseCase { CheckPetInfoUseCaseProvider() }
}

private var CheckPetInfoUseCaseProvider: () -> CheckPetInfoUseCase = {
  fatalError("PetUseCase Dependency not configured")
}

public func CheckPetInfoUseCaseRegister(
  provider: @escaping () -> CheckPetInfoUseCase
) {
  CheckPetInfoUseCaseProvider = provider
}

extension DependencyValues {
  public var CheckPetInfoUseCase: CheckPetInfoUseCase {
    get { self[CheckPetInfoUseCaseKey.self] }
    set { self[CheckPetInfoUseCaseKey.self] = newValue }
  }
}
