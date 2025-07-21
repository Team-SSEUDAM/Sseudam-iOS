//
//  FetchPetSeasonInfoUseCaseKey.swift
//  PetDomainInterface
//
//  Created by 조용인 on 7/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum FetchPetSeasonInfoUseCaseKey: DependencyKey {
  public static var liveValue: FetchPetSeasonInfoUseCase { FetchPetSeasonInfoUseCaseProvider() }
  public static var previewValue: FetchPetSeasonInfoUseCase { FetchPetSeasonInfoUseCaseProvider() }
  public static var testValue: FetchPetSeasonInfoUseCase { FetchPetSeasonInfoUseCaseProvider() }
}

private var FetchPetSeasonInfoUseCaseProvider: () -> FetchPetSeasonInfoUseCase = {
  fatalError("PetUseCase Dependency not configured")
}

public func FetchPetSeasonInfoUseCaseRegister(
  provider: @escaping () -> FetchPetSeasonInfoUseCase
) {
  FetchPetSeasonInfoUseCaseProvider = provider
}

extension DependencyValues {
  public var FetchPetSeasonInfoUseCase: FetchPetSeasonInfoUseCase {
    get { self[FetchPetSeasonInfoUseCaseKey.self] }
    set { self[FetchPetSeasonInfoUseCaseKey.self] = newValue }
  }
}
