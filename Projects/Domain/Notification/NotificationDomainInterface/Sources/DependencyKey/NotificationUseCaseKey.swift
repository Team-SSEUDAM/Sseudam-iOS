//
//  NotificationDependencyKey.swift
//
//  NotificationDomainInterface
//
//  Created by Jiyeon
//

import Foundation
import Dependencies

public enum NotificationUseCaseKey: DependencyKey {
  public static var liveValue: NotificationUseCase { NotificationUseCaseProvider() }
  public static var previewValue: NotificationUseCase { NotificationUseCaseProvider() }
  public static var testValue: NotificationUseCase { NotificationUseCaseProvider() }
}

private var NotificationUseCaseProvider: () -> NotificationUseCase = {
  fatalError("NotificationUseCase Dependency not configured")
}

public func NotificationUseCaseRegister(
  provider: @escaping () -> NotificationUseCase
) {
  NotificationUseCaseProvider = provider
}

extension DependencyValues {
  public var NotificationUseCase: NotificationUseCase {
    get { self[NotificationUseCaseKey.self] }
    set { self[NotificationUseCaseKey.self] = newValue }
  }
}
