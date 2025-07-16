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

public extension PetRepository {
  static func live(networker: NetworkKit) -> PetRepository {
    return .init(
      getPetInfo: {
        let cacheKey = MyPetCacheKey.myPetInfo
        let cache = try await CacheActor.shared.MY_PET_INFO_CACHE
        if let hitData = await cache.value(forKey: cacheKey) {
          let entity = PetInfoEntity(hitData)
          return entity /// `cache-hit`인 경우, 캐시된 데이터를 반환
        }
        
        let endpoint = PetEndpoint.getPetInfo()
        let entity = try await networker.execute(with: endpoint).toEntity()
        
        let cacheModel = MyPetInfoCacheModel(
          nickname: entity.nickname,
          point: entity.currentPoint,
          levelType: entity.levelType.rawValue,
          maxLevelStandard: entity.goalPoint
        )
        try await cache.insert(cacheModel, forKey: cacheKey)
        /// `cache-miss`인 경우, 네트워크로부터 받은 데이터를 캐시에 저장하고 반환
        return entity
      }
    )
  }
}
