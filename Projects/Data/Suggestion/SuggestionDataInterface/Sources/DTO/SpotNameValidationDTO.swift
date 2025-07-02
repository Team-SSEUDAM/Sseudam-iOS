//
//  SpotNameValidationDTO.swift
//  SuggestionDataInterface
//
//  Created by 조용인 on 6/30/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit
import SuggestionDomainInterface

public struct SpotNameValidationDTO: DTO {
  public typealias Entity = Bool
  
  public let isValid: Bool
}

public extension SpotNameValidationDTO {
  func toEntity() -> Bool {
    return self.isValid
  }
}
