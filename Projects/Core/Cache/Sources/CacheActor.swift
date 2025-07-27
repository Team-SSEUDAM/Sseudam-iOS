//
//  CacheActor.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 캐시 접근을 위한 전역 액터
@globalActor
public actor CacheActor {
  public static let shared = CacheActor()
  
  private init() {}
  
  /// `CacheKey`에 대한 `TwoTierCache`(`MemoryCache` & `DiskCache`)를 관리하는 `Root Cache`입니다.
  private var rootCache: [String: Any] = [:]
  
  /// `TwoTierCache`를 찾아서(없다면 생성하고) 반환하는 메서드.
  private func cache<Key: CacheKey, Value: Codable & Sendable>(
    _ cacheKey: Key,
    ttl: TTLScale = .medium,
    eviction: EvictionPolicy = .lru(100)
  ) async throws -> TwoTierCache<Key, Value> {
    let cacheName = cacheKey.directory + ":" + cacheKey.identifier /// `{directory}:{identifier}` 형태로 캐시 이름 생성
    if let existingCache = rootCache[cacheName] as? TwoTierCache<Key, Value> { return existingCache }
    
    let newCache = try await TwoTierCache<Key, Value>(
      defaultTTL: ttl,
      eviction: eviction,
      key: cacheKey
    )
    
    rootCache[cacheName] = newCache
    return newCache
  }
}

extension CacheActor {
  
  /// `SAMPLE_CACHE`에 대한 `TwoTierCache`(`MemoryCache` & `DiskCache`)를 반환합니다.
  public var SAMPLE_CACHE: TwoTierCache<SampleCacheKey, [CacheModel]> {
    get async throws {
      return try await cache(
        .여기에는_캐시파일_이름,
        ttl: .high,
        eviction: .none
      )
    }
  }
  
  public var MY_PET_INFO_CACHE: TwoTierCache<MyPetCacheKey, MyPetInfoCacheModel> {
    get async throws {
      return try await cache(
        .myPetInfo,
        ttl: .low,
        eviction: .none
      )
    }
  }
  
  public var MY_PET_SEASON_INFO_CACHE: TwoTierCache<MyPetCacheKey, MyPetSeasonInfoCacheModel> {
    get async throws {
      return try await cache(
        .myPetSeasonInfo,
        ttl: .low,
        eviction: .none
      )
    }
  }
  
  public var MY_PET_HISTORY_INFO_CACHE: TwoTierCache<MyPetCacheKey, MyPetHistoryInfoCacheModel> {
    get async throws {
      return try await cache(
        .myPetHistoryInfo,
        ttl: .high,
        eviction: .none
      )
    }
  }
}

/*
 - 사용 예시
```
final class cacheExample {
  func fetchSpotList(latitude: Double, longitude: Double) async throws -> [CacheModel] {
    // 캐시 키 생성 (위치 기반)
    let cacheKey = SampleCacheKey.여기에는_캐시파일_이름
    
    /// 1. 캐시 확인
    let cache = try await CacheActor.shared.SAMPLE_CACHE
    if let cachedSpots = await cache.value(forKey: cacheKey) {
      print("✅ Cache Hit: 스팟 목록")
      return cachedSpots
    }
    
    /// 2. 캐시 미스 - API 호출
    print("❌ Cache Miss: API 호출")
    let spots = [CacheModel()] /// `실제로는 repository`등을 통해 받은 데이터
    // 3. 캐시 저장
    try await cache.insert(
      spots,
      forKey: cacheKey,
      ttl: .medium  // 30분
    )
    return spots
  }
}
```
*/
