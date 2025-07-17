//
//  ReportSpotDTO.swift
//  SuggestionDataInterface
//
//  Created by 조용인 on 7/7/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit
import ReportDomainInterface

public struct ReportSpotDTO: DTO {
  public typealias Entity = ReportSpotEntity
  
  public let reportId: UInt16
  public let presignedUrl: String?
}

public extension ReportSpotDTO {
  func toEntity() -> ReportSpotEntity {
    return ReportSpotEntity(imageUploadURL: presignedUrl)
  }
}
