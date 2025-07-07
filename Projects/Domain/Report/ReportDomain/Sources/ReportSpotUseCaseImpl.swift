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
    .init { spotId, spotname, centerPoint, nmReverseGeoCode, trashType in
      let input = ReportSpotInput(
        spotId: spotId,
        spotName: spotname,
        centerPoint: centerPoint,
        nmReverseGeoCode: nmReverseGeoCode,
        trashType: trashType
      )
      let entity = try await repository.reportSpot(input)
      return entity.imageUploadURL
    }
  }
}
