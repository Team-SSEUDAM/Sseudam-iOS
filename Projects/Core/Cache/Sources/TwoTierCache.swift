//
//  TwoTierCache.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// `TwoTierCache`는 메모리와 디스크를 함께 사용하는 캐시 구현체입니다.
/// - Description: 메모리와 디스크를 함께 사용하는 2단계 캐시 구현체로, 캐시 항목을 메모리에 저장하고, 디스크에도 저장합니다.
public actor TwoTierCache<Key: CacheKey, Value: Codable & Sendable> {
  
  private let memoryStorage: MemoryCacheStorage<Key, Value>
  private var expirationTimer: Task<Void, Never>?
  
  private let defaultTTL: TTLScale
  private let eviction: EvictionPolicy
  private let cacheKey: Key
  
  // 타입 별칭으로 가독성 향상
  private typealias DiskStorage = DiskCacheStorage<Key, Value>
  
  /// `TwoTierCache` 초기화
  ///
  /// - Parameters:
  ///  - defaultTTL: 기본 캐시 유지 시간 (기본값: `.medium`)
  ///  - eviction: 캐시 제거 정책 (기본값: `.lru(100)`)
  ///  - key: 캐시를 식별하는 키
  public init(
    defaultTTL: TTLScale = .medium,
    eviction: EvictionPolicy = .lru(100),
    key: Key
  ) async throws {
    self.defaultTTL = defaultTTL
    self.eviction = eviction
    self.memoryStorage = MemoryCacheStorage()
    self.cacheKey = key
    
    await loadFromDisk()
    await startExpirationTimer(interval: 60.0)
  }
  
  /// `TwoTierCache`가 `deinit`될 때, 즉 `TwoTierCache` 인스턴스가 사라질 때, `expirationTimer`도 같이 취소
  deinit { expirationTimer?.cancel() }
  
  /// 디스크에서 캐시 항목을 메모리로 로드 (`optional`)
  private func loadFromDisk() async {
    /// 필요한 경우 구현
    /// 예: 앱 시작 시 중요한 캐시를 미리 메모리에 로드
  }
  
  /// 제거 정책 적용
  /// - Discussion: 캐시 항목이 제한을 초과하면 제거 정책(`eviction`)에 따라 적절한 항목을 제거합니다.
  ///   - `.lru(maxCount)`: 최근에 사용된 항목을 우선적으로 제거 (메모리에서만)
  ///   - `.fifo(maxCount)`: 먼저 저장된 항목을 우선적으로 제거 (메모리에서만)
  ///   - `.size(maxSize)`: 캐시 크기 제한 (미구현)
  ///   - `.none`: 제거 정책 없음
  private func applyEvictionIfNeeded() throws {
    switch eviction {
    case let .lru(maxCount):
      let allKeys = try memoryStorage.allKeys()
      guard allKeys.count > maxCount else { return }
      
      /// 모든 항목과 마지막 접근 시간을 가져옴
      var entries: [(key: Key, entry: CacheEntry<Value>)] = []
      for key in allKeys {
        if let entry = try memoryStorage.retrieve(forKey: key) {
          entries.append((key, entry))
        }
      }
      
      /// 접근 시간 기준 정렬 (오래된 것부터)
      let sortedEntries = entries.sorted { $0.entry.lastAccessed < $1.entry.lastAccessed }
      
      /// 초과분 제거 (메모리에서만)
      let toRemove = sortedEntries.prefix(entries.count - maxCount)
      for (key, _) in toRemove { try memoryStorage.remove(forKey: key) }
      
    case let .fifo(maxCount):
      let allKeys = try memoryStorage.allKeys()
      guard allKeys.count > maxCount else { return }
      
      /// 모든 항목과 생성 시간을 가져옴
      var entries: [(key: Key, entry: CacheEntry<Value>)] = []
      for key in allKeys {
        if let entry = try memoryStorage.retrieve(forKey: key) {
          entries.append((key, entry))
        }
      }
      
      /// 생성 시간 기준 정렬 (오래된 것부터)
      let sortedEntries = entries.sorted { $0.entry.createdAt < $1.entry.createdAt }
      
      /// 초과분 제거 (메모리에서만)
      let toRemove = sortedEntries.prefix(entries.count - maxCount)
      for (key, _) in toRemove { try memoryStorage.remove(forKey: key) }
      
    case let .size(maxBytes): break
      /// TODO: 크기 기반 제거 정책 구현
      
    case .none: return
    }
  }
}

// MARK: - Public Cache Operations
public extension TwoTierCache {
  
  /// `key`에 해당하는 캐시 항목을 저장
  ///
  /// - Parameters:
  ///   - value: 저장할 값 (`Codable` & `Sendable`)
  ///   - key: 저장할 값의 키 (`CacheKey` -> `Namespace`로 구분)
  ///   - ttl: 캐시 유지 시간 (기본값: `defaultTTL`)
  ///
  /// - Note: Memory Cache -> Disk Cache 순서로 저장하며, 저장 이후 제거 정책(Eviction Policy)을 적용함
  func insert(
    _ value: Value,
    forKey key: Key,
    ttl: TTLScale? = nil
  ) async throws {
    let ttlValue = ttl ?? defaultTTL
    let expiration = Date().addingTimeInterval(ttlValue.timeInterval)
    let entry = CacheEntry(value: value, expiration: expiration)
    /// 1. 우선 Memory Cache에 저장 (동기, 빠름)
    try memoryStorage.store(entry, forKey: key)
    /// 2. 제거 정책 적용 (메모리가 가득 찰 수 있으므로)
    try applyEvictionIfNeeded()
    /// 3. 추가적으로 Disk Cache에 저장 (비동기, 백그라운드) - `디스크 저장 실패는 무시 (메모리 캐시는 유지)`
    try? await DiskStorage.store(entry, forKey: key)
  }
  
  /// `Memory Cache` -> `Disk Cache` 순서로 확인하며, 캐시 항목 반환 (Cache Miss 시 nil 반환)
  ///
  /// - Parameters:
  ///   - key: 캐시 항목을 찾기 위한 키
  ///
  /// - Note: Memory Cache -> Disk Cache 순서로 확인하며, Cache Miss 시 nil 반환
  func value(forKey key: Key) async -> Value? {
    /// 1. 먼저 Memory Cache 확인 (동기, 빠름)
    if let entry = try? memoryStorage.retrieve(forKey: key) {
      let updatedEntry = entry.accessed() /// LRU 정책을 위해 접근 시간 업데이트
      try? memoryStorage.store(updatedEntry, forKey: key)
      return entry.value /// 메모리에서 찾은 항목 반환
    }
    
    /// 2. Memory에 없으면, Disk Cache 확인 (비동기, 백그라운드)
    if let entry = try? await DiskStorage.retrieve(forKey: key) {
      /// 디스크에서 찾은 항목을 메모리에 캐싱
      let updatedEntry = entry.accessed()
      try? memoryStorage.store(updatedEntry, forKey: key)
      /// 메모리에 추가되었으므로 제거 정책 확인
      try? applyEvictionIfNeeded()
      /// 접근 시간 업데이트를 위해 디스크에도 다시 저장
      Task { try? await DiskStorage.store(updatedEntry, forKey: key) }
      return entry.value /// 디스크에서 찾은 항목 반환
    }
    
    /// 3. 둘 다 없으면 nil 반환 -> Cache Miss
    return nil
  }
  
  /// Memory & Disk Cache에서 key에 해당하는 캐시 항목 제거
  func remove(forKey key: Key) async {
    /// 1. Memory Cache에서 제거 (동기, 빠름)
    try? memoryStorage.remove(forKey: key)
    /// 2. Disk Cache에서 제거 (비동기, 백그라운드)
    try? await DiskStorage.removeDiskCache(for: key)
  }
  
  /// Memory & Disk Cache 모두 초기화
  func removeAll() async {
    /// 1. Memory Cache 초기화 (동기, 빠름)
    try? memoryStorage.removeAll()
    /// 2. Disk Cache 초기화 (비동기, 백그라운드)
    try? await DiskStorage.removeDiskCache(for: cacheKey, withDirectory: true)
  }
  
  /// 만료된 캐시 항목 제거
  func removeExpired() async {
    /// 1. Memory Cache에서 만료된 항목 제거 (동기, 빠름)
    try? memoryStorage.removeExpired()
    /// 2. Disk Cache에서 만료된 항목 제거 (비동기, 백그라운드)
    try? await DiskStorage.removeExpiredInDirectory(for: cacheKey)
  }
  
  /// 일정 시간(interval)마다, Memory & Disk Cache에서 Expired 지난 항목들 제거
  ///
  /// - Parameters:
  ///   - interval: 시간 간격 (`초 단위`)
  ///
  /// - Note: `TwoTierCache`가 `deinit`될 때, 즉 `TwoTierCache` 인스턴스가 사라질 때, `expirationTimer`도 같이 취소
  func startExpirationTimer(interval: TimeInterval) async {
    expirationTimer?.cancel()
    
    expirationTimer = Task.detached { [weak self] in
      while !Task.isCancelled {
        try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
        guard let self = self else { return }
        await self.removeExpired()
      }
    }
  }
  
  /// 만료 타이머 중지
  func stopExpirationTimer() {
    expirationTimer?.cancel()
    expirationTimer = nil
  }
  
  /// 캐시 통계 정보 반환
  func statistics() async throws -> CacheStatistics {
    let memoryCount = try memoryStorage.allKeys().count
    let diskCount = try await DiskStorage.cacheFileCount(for: cacheKey)
    let diskSize = try await DiskStorage.calculateDirectorySize(for: cacheKey)
    
    return CacheStatistics(
      memoryItemCount: memoryCount,
      diskItemCount: diskCount,
      diskSizeInBytes: diskSize
    )
  }
  
  /// 메모리 캐시만 비우기 (디스크는 유지)
  func clearMemory() {
    try? memoryStorage.removeAll()
  }
  
  /// 캐시 항목 존재 여부 확인
  func contains(key: Key) async -> Bool {
    if (try? memoryStorage.retrieve(forKey: key)) != nil { return true }
    if (try? await DiskStorage.retrieve(forKey: key)) != nil { return true }
    return false
  }
}

// MARK: - Supporting Types

/// 캐시 통계 정보
public struct CacheStatistics {
  public let memoryItemCount: Int
  public let diskItemCount: Int
  public let diskSizeInBytes: Int64
  
  public var diskSizeInMB: Double {
    Double(diskSizeInBytes) / 1024 / 1024
  }
  
  public var diskSizeInKB: Double {
    Double(diskSizeInBytes) / 1024
  }
  
  public var description: String {
    """
    캐시 통계:
    - Memory Items: \(memoryItemCount)
    - Disk Items: \(diskItemCount)
    - Disk Size: \(String(format: "%.2f", diskSizeInMB)) MB
    """
  }
}
