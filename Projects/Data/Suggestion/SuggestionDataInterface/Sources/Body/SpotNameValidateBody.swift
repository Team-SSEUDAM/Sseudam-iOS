//
//  SpotNameValidateBody.swift
//  SuggestionDataInterface
//
//  Created by 조용인 on 6/30/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import SuggestionDomainInterface

public struct SpotNameValidateBody: Encodable {
  public let name: String
  
  public init(_ input: SpotNameValidateInput) {
    self.name = input.name
  }
}
