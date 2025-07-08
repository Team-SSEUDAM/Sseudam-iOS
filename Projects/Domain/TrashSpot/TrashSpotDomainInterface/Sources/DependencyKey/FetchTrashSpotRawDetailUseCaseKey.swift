//
//  FetchTrashSpotRawDetailUseCaseKey.swift
//  TrashSpotDomainInterface
//
//  Created by 조용인 on 7/8/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum FetchTrashSpotRawDetailUseCaseKey: DependencyKey {
  public static var liveValue: FetchTrashSpotRawDetailUseCase { FetchTrashSpotRawDetailUseCaseProvider() }
  public static var previewValue: FetchTrashSpotRawDetailUseCase { FetchTrashSpotRawDetailUseCaseProvider() }
  public static var testValue: FetchTrashSpotRawDetailUseCase { FetchTrashSpotRawDetailUseCaseProvider() }
}

private var FetchTrashSpotRawDetailUseCaseProvider: () -> FetchTrashSpotRawDetailUseCase = {
  fatalError("FetchTrashSpotDetailUseCase Dependency not configured")
}

public func FetchTrashSpotRawDetailUseCaseRegister(
  provider: @escaping () -> FetchTrashSpotRawDetailUseCase
) {
  FetchTrashSpotRawDetailUseCaseProvider = provider
}

extension DependencyValues {
  public var FetchTrashSpotRawDetailUseCase: FetchTrashSpotRawDetailUseCase {
    get { self[FetchTrashSpotRawDetailUseCaseKey.self] }
    set { self[FetchTrashSpotRawDetailUseCaseKey.self] = newValue }
  }
}


