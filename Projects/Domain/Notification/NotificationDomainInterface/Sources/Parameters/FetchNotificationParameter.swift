//
//  FetchNotificationParameter.swift
//  NotificationDomainInterface
//
//  Created by Jiyeon on 10/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct FetchNotificationParameter: Encodable {
  public var userId: Int
  public var size: Int
  public var lastId: Int?
}
