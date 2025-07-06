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
  public var fetchTrashSpotDetail: @Sendable (_ id: Int) async throws -> TrashSpotDetail
  
  public init(
    fetchTrashSpot: @Sendable @escaping (FetchTrashSpotParameter) async throws -> [TrashSpot],
    fetchTrashSpotDetail: @Sendable @escaping (_ id: Int) async throws -> TrashSpotDetail
  ) {
    self.fetchTrashSpot = fetchTrashSpot
    self.fetchTrashSpotDetail = fetchTrashSpotDetail
  }
}
