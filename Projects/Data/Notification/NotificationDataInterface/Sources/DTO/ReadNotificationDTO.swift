//
//  ReadNotificationDTO.swift
//  NotificationDataInterface
//
//  Created by Jiyeon on 10/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NotificationDomainInterface
import NetworkKit

public struct ReadNotificationDTO: DTO {
  public typealias Entity = Void
  public let message: String
  
  public func toEntity() throws -> Void {
    return ()
  }
}
