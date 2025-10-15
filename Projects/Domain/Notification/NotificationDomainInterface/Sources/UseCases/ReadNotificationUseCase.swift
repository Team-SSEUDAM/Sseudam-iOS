//
//  ReadNotificationUseCase.swift
//  NotificationDomainInterface
//
//  Created by Jiyeon on 10/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct ReadNotificationUseCase {
  public var execute: @Sendable (_ userId: Int, _ notiId: Int) async throws -> Void
  
  public init(execute: @Sendable @escaping (_ userId: Int, _ notiId: Int) async throws -> Void) {
    self.execute = execute
  }
}
