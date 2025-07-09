//
//  ReportSpotNameValidateUseCaseImpl.swift
//  ReportDomain
//
//  Created by 조용인 on 7/7/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ReportDomainInterface

extension ReportSpotNameValidateUseCase {
  public static func live(repository: ReportRepository) -> ReportSpotNameValidateUseCase {
    .init { spotName in
      let input = ReportSpotNameValidateInput(spotName: spotName)
      return try await repository.getReportSpotValidation(input)
    }
  }
}
