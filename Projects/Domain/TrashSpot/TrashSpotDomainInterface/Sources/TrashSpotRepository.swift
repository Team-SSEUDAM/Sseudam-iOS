//
//  TrashSpotRepository.swift
//
//  TrashSpotDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct TrashSpotRepository {
  public var fetchTrashSpot: @Sendable (FetchTrashSpotParameter) async throws -> [TrashSpot]
  
  public init(
    fetchTrashSpot: @Sendable @escaping (FetchTrashSpotParameter) async throws -> [TrashSpot]
  ) {
    self.fetchTrashSpot = fetchTrashSpot
  }
}
