//
//  TrashSpotRepositoryImpl.swift
//
//  TrashSpot
//
//  Created by JiYeon
//

import Foundation
import TrashSpotDomainInterface
import TrashSpotDataInterface
import NetworkKit
import Utility
import Cache

public extension TrashSpotRepository {
  static func live(networker: NetworkKit) -> TrashSpotRepository {
    .init(
      fetchTrashSpot: { parameter in
        let endpoint = TrashSpotEndPoint.fetchTrashSpot(parameter: parameter)
        return try await networker.execute(with: endpoint, timeout: 60).toEntity()
       },
      fetchTrashSpotDetail: { id in
        let endpoint = TrashSpotEndPoint.fetchTrashSpotDetail(spotId: id)
        let entity = try await networker.execute(with: endpoint, timeout: 60).toEntity()
        
        let cacheKey = TrashSpotCacheKey.trashSpotDetail(id: id)
        let cache = try await CacheActor.shared.TRASH_SPOT_DETAIL_CACHE(id: id)
        let cacheModel = entity.makeCacheModel()
        await cache.remove(forKey: cacheKey)
        
        try await cache.insert(cacheModel, forKey: cacheKey)
        return entity
      },
      fetchTrashSpotDetailCache: { id in
        let cacheKey = TrashSpotCacheKey.trashSpotDetail(id: id)
        let cache = try await CacheActor.shared.TRASH_SPOT_DETAIL_CACHE(id: id)
        guard let hitData = await cache.value(forKey: cacheKey) else {
          throw CacheError.fileNotFound
        }
        return TrashSpotDetail(hitData)
      },
      fetchTrashSpotDetailFlatten: { id in
        let endpoint = TrashSpotEndPoint.fetchTrashSpotDetail(spotId: id)
        return try await networker.execute(with: endpoint, timeout: 60).toFlattenEntity()
      }
    )
  }
}
