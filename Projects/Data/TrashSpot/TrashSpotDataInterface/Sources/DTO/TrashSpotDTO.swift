//
//  TrashSpotDto.swift
//
//  TrashSpot
//
//  Created by JiYeon
//

import Foundation
import TrashSpotDomainInterface
import NetworkKit
import DesignKit

public struct TrashSpotListDTO: DTO {
  public let list: [TrashSpotDTO]
  
  public func toEntity() throws -> [TrashSpot] {
    return try list.map { try $0.toEntity() }
  }
}

public struct TrashSpotDTO: DTO {
  public let id: Int
  public let name: String
  public let region: String
  public let address: AddressDTO
  public let point: PointDTO
  public let trashType: String
  
  public func toEntity() throws -> TrashSpot {
    let address: String = try address.toEntity().address
    let point: MapPoint = try point.toEntity()
    return .init(
      id: id,
      name: name,
      region: region,
      address: address,
      location: point,
      trashType: TrashType(rawValue: trashType) ?? .general
    )
  }
}
