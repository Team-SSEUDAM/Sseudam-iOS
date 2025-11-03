//
//  PetInfoDTO.swift
//
//  Pet
//
//  Created by yongin
//

import Foundation
import PetDomainInterface
import NetworkKit

public struct PetInfoDTO: DTO {
  public typealias Entity = PetInfoEntity
  
  public let userId: Int
  public let petId: Int
  public let nickname: String
  public let point: Int
  public let levelType: String
  public let maxLevelStandard: Int
  public let season: String
  public let createdAt: String
}

public extension PetInfoDTO {
  func toEntity() -> Entity {
    return PetInfoEntity(
      nickname: nickname,
      point: point,
      levelType: levelType,
      maxLevelStandard: maxLevelStandard,
      season: season
    )
  }
}
