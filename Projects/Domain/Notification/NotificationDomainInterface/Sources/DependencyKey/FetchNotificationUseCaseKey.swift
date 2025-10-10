//
//  FetchNotificationUseCaseKey.swift
//  NotificationDomainInterface
//
//  Created by Jiyeon on 10/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum FetchNotificationUseCaseKey: DependencyKey {
  public static var liveValue: FetchNotificationUseCase { FetchNotificationUseCaseProvider() }
  public static var previewValue: FetchNotificationUseCase { FetchNotificationUseCaseProvider() }
  public static var testValue: FetchNotificationUseCase { FetchNotificationUseCaseProvider() }
}

private var FetchNotificationUseCaseProvider: () -> FetchNotificationUseCase = {
  fatalError("FetchNotificationUseCase Dependency not configured")
}

public func FetchNotificationUseCaseRegister(
  provider: @escaping () -> FetchNotificationUseCase
) {
  FetchNotificationUseCaseProvider = provider
}

extension DependencyValues {
  public var FetchNotificationUseCase: FetchNotificationUseCase {
    get { self[FetchNotificationUseCaseKey.self] }
    set { self[FetchNotificationUseCaseKey.self] = newValue }
  }
}

