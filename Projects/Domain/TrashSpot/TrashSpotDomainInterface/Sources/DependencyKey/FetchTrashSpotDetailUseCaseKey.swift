//
//  FetchTrashSpotDetailUseCaseKey.swift
//  TrashSpotDomainInterface
//
//  Created by Jiyeon on 7/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum FetchTrashSpotDetailUseCaseKey: DependencyKey {
  public static var liveValue: FetchTrashSpotDetailUseCase { FetchTrashSpotDetailUseCaseProvider() }
  public static var previewValue: FetchTrashSpotDetailUseCase { FetchTrashSpotDetailUseCaseProvider() }
  public static var testValue: FetchTrashSpotDetailUseCase { FetchTrashSpotDetailUseCaseProvider() }
}

private var FetchTrashSpotDetailUseCaseProvider: () -> FetchTrashSpotDetailUseCase = {
  fatalError("FetchTrashSpotDetailUseCase Dependency not configured")
}

public func FetchTrashSpotDetailUseCaseRegister(
  provider: @escaping () -> FetchTrashSpotDetailUseCase
) {
  FetchTrashSpotDetailUseCaseProvider = provider
}

extension DependencyValues {
  public var FetchTrashSpotDetailUseCase: FetchTrashSpotDetailUseCase {
    get { self[FetchTrashSpotDetailUseCaseKey.self] }
    set { self[FetchTrashSpotDetailUseCaseKey.self] = newValue }
  }
}


