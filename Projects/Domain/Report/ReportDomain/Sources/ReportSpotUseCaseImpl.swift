//
//  ReportSpotUseCaseImpl.swift
//
//  ReportDomain
//
//  Created by yongin
//

import Foundation
import ReportDomainInterface
import NMReverseGeocodingDomainInterface

extension ReportSpotUseCase {
  public static func live(repository: ReportRepository) -> ReportSpotUseCase {
    .init { reportType, spotDetail in
      let input = ReportSpotInput(
        reportType: reportType,
        spotDetail: spotDetail
      )
      let entity = try await repository.postReportSpot(input)
      return entity.imageUploadURL
    }
  }
}
