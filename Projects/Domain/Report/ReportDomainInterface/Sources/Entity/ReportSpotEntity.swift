//
//  ReportSpotEntity.swift
//  ReportDomainInterface
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct ReportSpotEntity: Sendable, Equatable {
  public let imageUploadURL: String
  
  public init(imageUploadURL: String) {
    self.imageUploadURL = imageUploadURL
  }
}

