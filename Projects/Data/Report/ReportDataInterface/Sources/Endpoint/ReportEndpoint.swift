//
//  ReportEndpoint.swift
//  ReportDataInterface
//
//  Created by 조용인 on 6/29/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit
import UserDefaults
import ReportDomainInterface

public enum ReportEndpoint: Sendable {
  
  public static func postSpotReport(
    addPath: Int,
    body: ReportSpotBody
  ) -> Endpoint<ReportSpotDTO> {
    return Endpoint(
      headers: .authorization(UserDefaultsKeys.accessToken),
      method: .post,
      path: "/reports/\(addPath)",
      parameters: .body(body)
    )
  }
  
  public static func getReportSpotNameValidation(
    body: ReportSpotNameValidateBody
  ) -> Endpoint<ReportSpotNameValidationDTO> {
    return Endpoint(
      headers: .authorization(UserDefaultsKeys.accessToken),
      method: .post,
      path: "/reports/validate",
      parameters: .body(body)
    )
  }
  
  public static func getReportDetail(reportId: Int, body: ReportDetailBody) -> Endpoint<ReportDetailDTO> {
    return Endpoint(
      headers: .authorization(UserDefaultsKeys.accessToken),
      method: .post,
      path: "/reports/\(reportId)",
      parameters: .body(body)
    )
  }
}
