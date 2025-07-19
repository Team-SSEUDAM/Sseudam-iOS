//
//  PetRepositoryImpl.swift
//
//  Pet
//
//  Created by yongin
//

import Foundation
import PetDomainInterface
import PetDataInterface
import NetworkKit
import Cache
import Utility

public extension PetRepository {
  static func live(networker: NetworkKit) -> PetRepository {
    return .init(
      getPetInfo: {
        let endpoint = PetEndpoint.getPetInfo()
        let entity = try await networker.execute(with: endpoint).toEntity()
        
        let cacheKey = MyPetCacheKey.myPetInfo
        let cache = try await CacheActor.shared.MY_PET_INFO_CACHE
        let cacheModel = entity.makeCacheModel()
        await cache.remove(forKey: cacheKey)
        try await cache.insert(cacheModel, forKey: cacheKey)
        return entity
      },
      getPetInfoFromCache: {
        let cacheKey = MyPetCacheKey.myPetInfo
        let cache = try await CacheActor.shared.MY_PET_INFO_CACHE
        guard let hitData = await cache.value(forKey: cacheKey) else {
          throw CacheError.fileNotFound /// 이 때, api 호출 필요
        }
        return PetInfoEntity(hitData)
       },
      getPetSeasonInfo: {
        let endpoint = PetEndpoint.getPetSeasonInfo()
        let entity = try await networker.execute(with: endpoint).toEntity()
        
        let cacheKey = MyPetCacheKey.myPetSeasonInfo
        let cache = try await CacheActor.shared.MY_PET_SEASON_INFO_CACHE
        let cacheModel = entity.makeCacheModel()
        
        await cache.remove(forKey: cacheKey)
        try await cache.insert(cacheModel, forKey: cacheKey)
        return entity
      },
      getPetSeasonInfoFromCache: {
        let cacheKey = MyPetCacheKey.myPetSeasonInfo
        let cache = try await CacheActor.shared.MY_PET_SEASON_INFO_CACHE
        guard let hitData = await cache.value(forKey: cacheKey) else {
          throw CacheError.fileNotFound /// 이 때, api 호출 필요
        }
        return PetSeasonInfoEntity(hitData)
      }
    )
  }
}
