//
//  FCMTokenBody.swift
//  UserDataInterface
//
//  Created by 조용인 on 10/8/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct FCMTokenBody: Encodable {
  let fcmToken: String
  
  public init(fcmToken: String) {
    self.fcmToken = fcmToken
  }
}
