//
//  ReportDetailInput.swift
//  ReportDomainInterface
//
//  Created by Jiyeon on 10/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct ReportDetailInput {
  public let userId: Int
  public let reportId: Int
  
  public init(userId: Int, reportId: Int) {
    self.userId = userId
    self.reportId = reportId
  }
}
