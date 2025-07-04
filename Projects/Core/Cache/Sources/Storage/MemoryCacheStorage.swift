//
//  MemoryCacheStorage.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

// MARK: - Memory Cache <- 우선순위 높음
final class MemoryCacheStorage<Key: Hashable, Value: Codable & Sendable> {
  private var storage: [Key: CacheEntry<Value>] = [:]
  
  func store(_ entry: CacheEntry<Value>, forKey key: Key) throws {
    storage[key] = entry
  }
  
  func retrieve(forKey key: Key) throws -> CacheEntry<Value>? {
    guard let entry = storage[key] else { return nil }
    return entry.isExpired ? nil : entry
  }
  
  func remove(forKey key: Key) throws {
    storage.removeValue(forKey: key)
  }
  
  // async 키워드도 제거 가능
  func removeAll() throws {
    storage.removeAll()
  }
  
  func removeExpired() throws {
    let now = Date()
    storage = storage.filter { $0.value.expiration >= now }
  }
  
  func allKeys() throws -> [Key] {
    return Array(storage.keys)
  }
}
