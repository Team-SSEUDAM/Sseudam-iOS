//
//  FetchNotificationUseCase.swift
//  NotificationDomainInterface
//
//  Created by Jiyeon on 10/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct FetchNotificationUseCase {
  public var execute: @Sendable (FetchNotificationParameter) async throws -> NotificationListEntity?
  
  public init(execute: @Sendable @escaping (FetchNotificationParameter) async throws -> NotificationListEntity?) {
    self.execute = execute
  }
}
