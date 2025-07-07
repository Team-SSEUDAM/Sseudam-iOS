//
//  ReportSpotNameValidateInput.swift
//  ReportDomainInterface
//
//  Created by 조용인 on 7/7/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct ReportSpotNameValidateInput: Codable, Equatable {
  public let name: String
  
  public init(spotName: String) {
    self.name = spotName
  }
}
