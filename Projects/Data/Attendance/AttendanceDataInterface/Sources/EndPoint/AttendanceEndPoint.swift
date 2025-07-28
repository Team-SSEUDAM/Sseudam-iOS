//
//  AttendanceEndPoint.swift
//  AttendanceDataInterface
//
//  Created by Jiyeon on 7/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import AttendanceDomainInterface
import NetworkKit
import UserDefaults

public struct AttendanceEndPoint: Sendable {
  public static func checkAttendance(parameter: AttendanceBody) -> Endpoint<AttendanceDTO> {
    let accessToken = UserDefaultsKeys.accessToken
    return Endpoint(
      headers: .authorization(accessToken),
      method: .post,
      path: "/attendance",
      parameters: .query(parameter)
    )
  }
}
