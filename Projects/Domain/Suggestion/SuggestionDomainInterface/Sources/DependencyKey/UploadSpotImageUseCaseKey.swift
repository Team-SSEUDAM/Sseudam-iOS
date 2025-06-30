//
//  UploadSpotImageUseCaseKey.swift
//  SuggestionDomainInterface
//
//  Created by 조용인 on 6/29/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum UploadSpotImageUseCaseKey: DependencyKey {
  public static var liveValue: UploadSpotImageUseCase { UploadSpotImageUseCaseProvider() }
  public static var previewValue: UploadSpotImageUseCase { UploadSpotImageUseCaseProvider() }
  public static var testValue: UploadSpotImageUseCase { UploadSpotImageUseCaseProvider() }
}

private var UploadSpotImageUseCaseProvider: () -> UploadSpotImageUseCase = {
  fatalError("SuggestionUseCase Dependency not configured")
}

public func UploadSpotImageUseCaseRegister(
  provider: @escaping () -> UploadSpotImageUseCase
) {
  UploadSpotImageUseCaseProvider = provider
}

extension DependencyValues {
  public var UploadSpotImageUseCase: UploadSpotImageUseCase {
    get { self[UploadSpotImageUseCaseKey.self] }
    set { self[UploadSpotImageUseCaseKey.self] = newValue }
  }
}
