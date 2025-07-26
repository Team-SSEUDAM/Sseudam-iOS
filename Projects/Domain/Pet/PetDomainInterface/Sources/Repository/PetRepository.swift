//
//  PetRepository.swift
//
//  PetDomainInterface
//
//  Created by yongin
//

import Foundation
import Cache

public struct PetRepository {
  
  public var getPetInfo: @Sendable () async throws -> PetInfoEntity
  public var getPetInfoFromCache: @Sendable () async throws -> PetInfoEntity
  public var getPetSeasonInfo: @Sendable () async throws -> PetSeasonInfoEntity
  public var getPetSeasonInfoFromCache: @Sendable () async throws -> PetSeasonInfoEntity
  public var getPetHistoryInfo: @Sendable () async throws -> PetHistoryInfoEntity

  public init(
    getPetInfo: @Sendable @escaping () async throws -> PetInfoEntity,
    getPetInfoFromCache: @Sendable @escaping () async throws -> PetInfoEntity,
    getPetSeasonInfo: @Sendable @escaping () async throws -> PetSeasonInfoEntity,
    getPetSeasonInfoFromCache: @Sendable @escaping () async throws -> PetSeasonInfoEntity,
    getPetHistoryInfo: @Sendable @escaping () async throws -> PetHistoryInfoEntity
  ) {
    self.getPetInfo = getPetInfo
    self.getPetInfoFromCache = getPetInfoFromCache
    self.getPetSeasonInfo = getPetSeasonInfo
    self.getPetSeasonInfoFromCache = getPetSeasonInfoFromCache
    self.getPetHistoryInfo = getPetHistoryInfo
  }
}
