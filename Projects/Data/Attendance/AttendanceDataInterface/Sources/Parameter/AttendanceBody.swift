//
//  AttendanceBody.swift
//  AttendanceDataInterface
//
//  Created by Jiyeon on 7/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct AttendanceBody: Encodable {
  let user: Int
  
  public init(user: Int) {
    self.user = user
  }
}
