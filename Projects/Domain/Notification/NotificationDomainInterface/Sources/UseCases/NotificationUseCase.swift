//
//  NotificationUseCase.swift
//
//  NotificationDomainInterface
//
//  Created by Jiyeon
//

import Foundation

public struct NotificationUseCase {
  public var execute: @Sendable () async throws -> Void
  
  public init(execute: @Sendable @escaping () async throws -> Void) {
    self.execute = execute
  }
}
