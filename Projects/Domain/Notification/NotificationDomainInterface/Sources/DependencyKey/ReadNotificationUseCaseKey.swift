//
//  ReadNotificationUseCaseKey.swift
//  NotificationDomainInterface
//
//  Created by Jiyeon on 10/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum ReadNotificationUseCaseKey: DependencyKey {
  public static var liveValue: ReadNotificationUseCase { ReadNotificationUseCaseProvider() }
  public static var previewValue: ReadNotificationUseCase { ReadNotificationUseCaseProvider() }
  public static var testValue: ReadNotificationUseCase { ReadNotificationUseCaseProvider() }
}

private var ReadNotificationUseCaseProvider: () -> ReadNotificationUseCase = {
  fatalError("FetchNotificationUseCase Dependency not configured")
}

public func ReadNotificationUseCaseRegister(
  provider: @escaping () -> ReadNotificationUseCase
) {
  ReadNotificationUseCaseProvider = provider
}

extension DependencyValues {
  public var ReadNotificationUseCase: ReadNotificationUseCase {
    get { self[ReadNotificationUseCaseKey.self] }
    set { self[ReadNotificationUseCaseKey.self] = newValue }
  }
}

