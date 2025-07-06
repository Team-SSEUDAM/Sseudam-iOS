//
//  FetchTrashSpotUseCaseKey.swift
//  TrashSpotDomainInterface
//
//  Created by Jiyeon on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum FetchTrashSpotUseCaseKey: DependencyKey {
  public static var liveValue: FetchTrashSpotUseCase { FetchTrashSpotUseCaseProvider() }
  public static var previewValue: FetchTrashSpotUseCase { FetchTrashSpotUseCaseProvider() }
  public static var testValue: FetchTrashSpotUseCase { FetchTrashSpotUseCaseProvider() }
}

private var FetchTrashSpotUseCaseProvider: () -> FetchTrashSpotUseCase = {
  fatalError("TrashSpotUseCase Dependency not configured")
}

public func FetchTrashSpotUseCaseRegister(
  provider: @escaping () -> FetchTrashSpotUseCase
) {
  FetchTrashSpotUseCaseProvider = provider
}

extension DependencyValues {
  public var FetchTrashSpotUseCase: FetchTrashSpotUseCase {
    get { self[FetchTrashSpotUseCaseKey.self] }
    set { self[FetchTrashSpotUseCaseKey.self] = newValue }
  }
}
