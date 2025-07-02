//
//  SpotNameValidateInput.swift
//  SuggestionDomainInterface
//
//  Created by 조용인 on 6/30/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct SpotNameValidateInput: Codable, Equatable {
  public let name: String
  
  public init(spotName: String) {
    self.name = spotName
  }
}
