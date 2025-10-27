//
//  SuggestionDetailInput.swift
//  SuggestionDomainInterface
//
//  Created by Jiyeon on 10/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct SuggestionDetailInput: Equatable {
  public let userId: Int
  public let suggestionId: Int
  
  public init(userId: Int, suggestionId: Int) {
    self.userId = userId
    self.suggestionId = suggestionId
  }
}
