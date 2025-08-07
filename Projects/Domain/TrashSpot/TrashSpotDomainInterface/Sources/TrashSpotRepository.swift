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
  public var fetchTrashSpotDetailCache: @Sendable (_ id: Int) async throws -> TrashSpotDetail
  public var fetchTrashSpotDetailFlatten: @Sendable (_ id: Int) async throws -> TrashSpotFlattenDetailEntity
  
  public init(
    fetchTrashSpot: @Sendable @escaping (FetchTrashSpotParameter) async throws -> [TrashSpot],
    fetchTrashSpotDetail: @Sendable @escaping (_ id: Int) async throws -> TrashSpotDetail,
    fetchTrashSpotDetailCache: @Sendable @escaping (_ id: Int) async throws -> TrashSpotDetail,
    fetchTrashSpotDetailFlatten: @Sendable @escaping (_ id: Int) async throws -> TrashSpotFlattenDetailEntity
  ) {
    self.fetchTrashSpot = fetchTrashSpot
    self.fetchTrashSpotDetail = fetchTrashSpotDetail
    self.fetchTrashSpotDetailCache = fetchTrashSpotDetailCache
    self.fetchTrashSpotDetailFlatten = fetchTrashSpotDetailFlatten
  }
}
