//
//  AddressDTO.swift
//  TrashSpotDataInterface
//
//  Created by Jiyeon on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import TrashSpotDomainInterface
import NetworkKit

public struct AddressDTO: DTO {
  public let city: String
  public let site: String
  
  public func toEntity() throws -> AddressEntity {
    return .init(address: site)
  }
}
