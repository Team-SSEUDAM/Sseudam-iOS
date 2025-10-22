//
//  ReportDetailBody.swift
//  ReportDataInterface
//
//  Created by Jiyeon on 10/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ReportDomainInterface

public struct ReportDetailBody: Encodable {
  public let user: Int
  
  public init(userId: Int) {
    self.user = userId
  }
}
