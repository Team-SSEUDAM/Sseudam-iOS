//
//  ReportSpotNameValidationDTO.swift
//  ReportDataInterface
//
//  Created by 조용인 on 7/7/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit
import ReportDomainInterface

public struct ReportSpotNameValidationDTO: DTO {
  public typealias Entity = Bool
  
  public let isValid: Bool
}

public extension ReportSpotNameValidationDTO {
  func toEntity() -> Bool {
    return self.isValid
  }
}
