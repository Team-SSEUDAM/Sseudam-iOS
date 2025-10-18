//
//  ReportAddressDTO.swift
//  ReportDataInterface
//
//  Created by Jiyeon on 10/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit

public struct ReportAddressDTO: DTO {
  public let city: String
  public let site: String
  
  public func toEntity() throws -> String {
    return site
  }
}
