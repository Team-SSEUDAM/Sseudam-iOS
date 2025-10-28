//
//  NotificationListDTO.swift
//  NotificationDataInterface
//
//  Created by Jiyeon on 10/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NotificationDomainInterface
import NetworkKit


public struct NotificationListDTO: DTO {
  public typealias Entity = NotificationListEntity
  
  public let list: [NotificationDTO]
  public let nextCursor: Int?
  
}

extension NotificationListDTO {
  
  public func toEntity() -> Entity {
    return .init(
      items: list.map { $0.toEntity() },
      nextCursor: nextCursor
    )
  }
  
}
