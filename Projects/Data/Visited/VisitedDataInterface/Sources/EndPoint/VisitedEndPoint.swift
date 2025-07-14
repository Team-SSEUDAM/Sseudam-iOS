//
//  VisitedEndPoint.swift
//  VisitedDataInterface
//
//  Created by Jiyeon on 7/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import VisitedDomainInterface
import NetworkKit
import UserDefaults

public struct VisitedEndPoint: Sendable {
  public static func visited(parameter: VisitedParameter, spotId: Int) -> Endpoint<VisitedDTO> {
    let accessToken = UserDefaultsKeys.accessToken
    return Endpoint(
      headers: .authorization(accessToken),
      method: .post,
      path: "/visited/\(spotId)",
      parameters: .query(parameter)
    )
  }
}
