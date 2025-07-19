//
//  DiskCacheStorage.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Utility

/// `DiskCacheStorage`는 디스크에 캐시 데이터를 저장하고 관리
/// 모든 작업은 백그라운드에서 수행되어 메인 스레드를 블로킹하지 않습니다.
struct DiskCacheStorage<Key: CacheKey, Value: Codable & Sendable> {
  
  // MARK: - Directory & File Management
  
  /// [캐시 디렉토리 경로] `~/Library/Caches/{directory}/.....`
  private static func cacheDirectoryURL(with key: Key) throws -> URL {
    guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      throw CacheError.directoryCreationFailed
    }
    return cacheDir.appendingPathComponent(key.directory, isDirectory: true)
  }
  
  /// `key`에 해당하는 캐시 디렉토리가 존재하는지 확인하고, 없으면 생성합니다.
  private static func checkDirectoryExists(with key: Key) throws {
    let cacheDirectory = try cacheDirectoryURL(with: key)
    if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
      try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
  }
  
  /// `key`를 기반으로 캐시 파일이 존재하는지 확인합니다.
  private static func isCacheFileExists(for key: Key) throws -> Bool {
    let fileURL = try cacheFileURL(for: key)
    return FileManager.default.fileExists(atPath: fileURL.path)
  }
  
  /// [캐시 파일 경로] `~/Library/Caches/{directory}/{identifier}.cache`
  private static func cacheFileURL(for key: Key) throws -> URL {
    let cacheDirectory = try cacheDirectoryURL(with: key)
    return cacheDirectory.appendingPathComponent(key.fileName)
  }
}

extension DiskCacheStorage {
  
  // MARK: - Cache Operations (All run in background)
  
  /// `key`를 기반으로 `CacheEntry`를 저장합니다.
  /// - Parameters:
  ///  - entry: 저장할 `CacheEntry` - (실제 저장되는 `cache` 데이터)
  ///  - key: `CacheEntry`를 식별할 수 있는 `Key`
  static func store(_ entry: CacheEntry<Value>, forKey key: Key) async throws {
    try await Task.detached(priority: .background) {
      let fileURL = try cacheFileURL(for: key)
      try checkDirectoryExists(with: key)
      let data = try JSONEncoder().encode(entry)
      try data.write(to: fileURL)
    }.value
  }
  
  /// `key`를 기반으로 `CacheEntry`를 조회합니다.
  /// - Parameters:
  ///   - key: 조회할 `CacheEntry`를 식별할 수 있는 `Key`
  /// - Returns: 유효한 `CacheEntry` 또는 nil (파일이 없거나 만료된 경우)
  @discardableResult
  static func retrieve(forKey key: Key) async throws -> CacheEntry<Value>? {
    try await Task.detached(priority: .background) {
      let fileURL = try cacheFileURL(for: key)
      guard try isCacheFileExists(for: key) else { return nil }
      let data = try Data(contentsOf: fileURL)
      let entry = try JSONDecoder().decode(CacheEntry<Value>.self, from: data)
      if entry.isExpired {
        try await removeFile(at: fileURL)
        return nil
      }
      return entry
    }.value
  }
  
  // MARK: - Remove Operations (All run in background)
  
  /// 특정 key의 캐시를 제거합니다.
  /// - Parameters:
  ///   - key: 제거할 캐시의 key
  ///   - withDirectory: true인 경우 디렉토리 전체를 삭제
  static func removeDiskCache(for key: Key, withDirectory: Bool = false) async throws {
    try await Task.detached(priority: .background) {
      if withDirectory {
        try await removeAllInDirectory(for: key)
      } else {
        let fileURL = try cacheFileURL(for: key)
        try await removeFile(at: fileURL)
      }
    }.value
  }
  
  /// 특정 디렉토리 내의 만료된 캐시들을 삭제합니다.
  static func removeExpiredInDirectory(for key: Key) async throws {
    try await Task.detached(priority: .background) {
      let cacheDirectory = try cacheDirectoryURL(with: key)
      guard FileManager.default.fileExists(atPath: cacheDirectory.path) else { return }
      let contents = try FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
      for fileURL in contents {
        guard let data = try? Data(contentsOf: fileURL),
              let entry = try? JSONDecoder().decode(CacheEntry<Value>.self, from: data)
        else { continue }
        if entry.isExpired { try await removeFile(at: fileURL) }
      }
    }.value
  }
  
  /// 특정 디렉토리의 모든 캐시를 삭제합니다. (내부 헬퍼 메서드)
  private static func removeAllInDirectory(for key: Key) async throws {
    let cacheDirectory = try cacheDirectoryURL(with: key)
    guard FileManager.default.fileExists(atPath: cacheDirectory.path) else { return }
    let contents = try FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
    for fileURL in contents { try await removeFile(at: fileURL) }
  }
  
  /// URL 기반의 캐시 파일 제거 (내부 헬퍼 메서드)
  private static func removeFile(at filePath: URL) async throws {
    if FileManager.default.fileExists(atPath: filePath.path) {
      try FileManager.default.removeItem(at: filePath)
    }
  }
  
  // MARK: - Utility Methods (All run in background)
  
  /// 캐시 디렉토리의 전체 크기를 계산합니다.
  static func calculateDirectorySize(for key: Key) async throws -> Int64 {
    try await Task.detached(priority: .background) {
      let cacheDirectory = try cacheDirectoryURL(with: key)
      guard FileManager.default.fileExists(atPath: cacheDirectory.path) else { return 0 }
      let contents = try FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey])
      var totalSize: Int64 = 0
      for fileURL in contents {
        let fileAttributes = try fileURL.resourceValues(forKeys: [.fileSizeKey])
        totalSize += Int64(fileAttributes.fileSize ?? 0)
      }
      return totalSize
    }.value
  }
  
  /// 캐시 디렉토리 내의 파일 개수를 반환합니다.
  static func cacheFileCount(for key: Key) async throws -> Int {
    try await Task.detached(priority: .background) {
      let cacheDirectory = try cacheDirectoryURL(with: key)
      guard FileManager.default.fileExists(atPath: cacheDirectory.path) else { return 0 }
      let contents = try FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
      return contents.count
    }.value
  }
}
