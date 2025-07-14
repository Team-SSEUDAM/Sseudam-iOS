//
//  ReportSpotNameValidateBody.swift
//  ReportDataInterface
//
//  Created by 조용인 on 7/7/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ReportDomainInterface

public struct ReportSpotNameValidateBody: Encodable {
  public let name: String
  
  public init(_ input: ReportSpotNameValidateInput) {
    self.name = input.name
  }
}
