//
//  SuggestionDetailBody.swift
//  SuggestionDataInterface
//
//  Created by Jiyeon on 10/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import SuggestionDomainInterface

public struct SuggestionDetailBody: Encodable {
  public let userId: Int
  
  public init(userId: Int) {
    self.userId = userId
  }
}
