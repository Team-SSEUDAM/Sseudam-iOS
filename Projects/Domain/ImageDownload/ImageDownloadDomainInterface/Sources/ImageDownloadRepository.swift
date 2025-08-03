//
//  ImageDownloadRepository.swift
//
//  ImageDownloadDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct ImageDownloadRepository {
  public var fetchImage: @Sendable (_ urlStr: String, _ id: Int) async throws -> Data?
  public var fetchImageCache: @Sendable (_ id: Int) async throws -> Data?

  public init(
    fetchImage: @Sendable @escaping (_ urlStr: String, _ id: Int) async throws -> Data?,
    fetchImageCache: @Sendable @escaping (_ id: Int) async throws -> Data?
  ) {
    self.fetchImage = fetchImage
    self.fetchImageCache = fetchImageCache
  }
}
