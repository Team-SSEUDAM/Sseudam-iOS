//
//  SpotSuggestionDTO.swift
//  SuggestionDataInterface
//
//  Created by 조용인 on 6/29/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit
import SuggestionDomainInterface

public struct SpotSuggestionDTO: DTO {
  public typealias Entity = SpotSuggestionEntity
  
  public let suggestionId: UInt16
  public let presignedUrl: String
}

public extension SpotSuggestionDTO {
  func toEntity() -> SpotSuggestionEntity {
    return SpotSuggestionEntity(imageUploadURL: presignedUrl)
  }
}
