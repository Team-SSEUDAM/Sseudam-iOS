//
//  ReportRepositoryImpl.swift
//
//  Report
//
//  Created by yongin
//

import Foundation
import ReportDomainInterface
import ReportDataInterface
import NetworkKit

public extension ReportRepository {
  static func live(networker: NetworkKit) -> ReportRepository {
    return .init(
      postReportSpot: { input in
        let body = ReportSpotBody(input)
        let endpoint = ReportEndpoint.postSpotReport(addPath: input.spotId, body: body)
        return try await networker.execute(with: endpoint).toEntity()
      }, putReportSpotImage: { input in
        return try await networker.upload(with: input.presignedUrl, data: input.image)
      } ,
      getReportSpotValidation: { input in
        let body = ReportSpotNameValidateBody(input)
        let endpoint = ReportEndpoint.getReportSpotNameValidation(body: body)
        return try await networker.execute(with: endpoint).toEntity()
      }
    )
  }
}
