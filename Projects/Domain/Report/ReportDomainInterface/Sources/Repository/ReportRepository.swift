//
//  ReportRepository.swift
//
//  ReportDomainInterface
//
//  Created by yongin
//

import Foundation

public struct ReportRepository {
  public var postReportSpot: @Sendable (
    _ input: ReportSpotInput
  ) async throws -> ReportSpotEntity
  
  public var putReportSpotImage: @Sendable (
    _ input: UploadReportSpotImageInput
  ) async throws -> Void
  
  public var getReportSpotValidation: @Sendable (
    _ input: ReportSpotNameValidateInput
  ) async throws -> Bool
  
  public var getReportDetail: @Sendable (
    _ input: ReportDetailInput
  ) async throws -> ReportDetailEntity
  
  public init(
    postReportSpot: @Sendable @escaping (
      _ input: ReportSpotInput
    ) async throws -> ReportSpotEntity,
    putReportSpotImage: @Sendable @escaping (
      _ input: UploadReportSpotImageInput
    ) async throws -> Void ,
    getReportSpotValidation: @Sendable @escaping (
      _ input: ReportSpotNameValidateInput
    ) async throws -> Bool,
    getReportDetail: @Sendable @escaping (
      _ input: ReportDetailInput
    ) async throws -> ReportDetailEntity
  ) {
    self.postReportSpot = postReportSpot
    self.putReportSpotImage = putReportSpotImage
    self.getReportSpotValidation = getReportSpotValidation
    self.getReportDetail = getReportDetail
  }
}
