//
//  NotificationListEntity.swift
//  NotificationDomainInterface
//
//  Created by Jiyeon on 10/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct NotificationListEntity: Sendable, Equatable {
  public var items: [NotificationEntity]
  public var nextCursor: Int?
  
  public init(
    items: [NotificationEntity],
    nextCursor: Int? = nil
  ) {
    self.items = items
    self.nextCursor = nextCursor
  }
  
}
