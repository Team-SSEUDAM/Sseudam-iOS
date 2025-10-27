//
//  SuggestionDetailDTO.swift
//  SuggestionDataInterface
//
//  Created by Jiyeon on 10/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit
import SuggestionDomainInterface
import Utility

public struct SuggestionDetailDTO: DTO {
  public typealias Entity = SuggestionDetailEntity
  
  public let id: Int
  public let point: SuggestionPointDTO
  public let address: SuggestionAddressDTO
  public let trashType: String
  public let imageUrl: String
  public let status: String
  public let rejectReason: String?
  public let createdAt: String
  
  public func toEntity() throws -> SuggestionDetailEntity {
    let address: String = try address.toEntity()
    let point: Coordinates = try point.toEntity()
    return .init(id: id, point: point, address: address, rejectReason: rejectReason ?? "")
  }
}

