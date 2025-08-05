//
//  ImageDownloadRepository.swift
//
//  ImageDownloadDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct ImageDownloadRepository {
  public var fetchTrashImage: @Sendable (_ urlStr: String, _ id: Int) async throws -> Data?
  public var fetchTrashImageCache: @Sendable (_ id: Int) async throws -> Data?

  public init(
    fetchTrashImage: @Sendable @escaping (_ urlStr: String, _ id: Int) async throws -> Data?,
    fetchTrashImageCache: @Sendable @escaping (_ id: Int) async throws -> Data?
  ) {
    self.fetchTrashImage = fetchTrashImage
    self.fetchTrashImageCache = fetchTrashImageCache
  }
}
