//
//  FetchPetHistoryInfoUseCaseKey.swift
//  PetDomainInterface
//
//  Created by 조용인 on 7/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum FetchPetHistoryInfoUseCaseKey: DependencyKey {
  public static var liveValue: FetchPetHistoryInfoUseCase { FetchPetHistoryInfoUseCaseProvider() }
  public static var previewValue: FetchPetHistoryInfoUseCase { FetchPetHistoryInfoUseCaseProvider() }
  public static var testValue: FetchPetHistoryInfoUseCase { FetchPetHistoryInfoUseCaseProvider() }
}

private var FetchPetHistoryInfoUseCaseProvider: () -> FetchPetHistoryInfoUseCase = {
  fatalError("PetUseCase Dependency not configured")
}

public func FetchPetHistoryInfoUseCaseRegister(
  provider: @escaping () -> FetchPetHistoryInfoUseCase
) {
  FetchPetHistoryInfoUseCaseProvider = provider
}

extension DependencyValues {
  public var FetchPetHistoryInfoUseCase: FetchPetHistoryInfoUseCase {
    get { self[FetchPetHistoryInfoUseCaseKey.self] }
    set { self[FetchPetHistoryInfoUseCaseKey.self] = newValue }
  }
}
