//
//  ReportDetailUseCaseImpl.swift
//  ReportDomain
//
//  Created by Jiyeon on 10/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ReportDomainInterface

extension ReportDetailUseCase {
  public static func live(repository: ReportRepository) -> ReportDetailUseCase {
    .init { userId, reportId in
      let input = ReportDetailInput(userId: userId, reportId: reportId)
      return try await repository.getReportDetail(input)
    }
  }
}
