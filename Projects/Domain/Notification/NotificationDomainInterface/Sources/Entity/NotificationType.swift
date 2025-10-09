//
//  NotificationType.swift
//  NotificationDomainInterface
//
//  Created by Jiyeon on 10/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public enum NotificationType {
  case trashThrow
  case accept
  case refuse
}

public struct NotificationEntity: Hashable {
  public var contents: String
  public var date: String
  public var type: NotificationType
  
}
