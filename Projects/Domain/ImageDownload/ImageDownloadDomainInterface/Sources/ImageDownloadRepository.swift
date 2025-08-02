//
//  ImageDownloadRepository.swift
//
//  ImageDownloadDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct ImageDownloadRepository {
  public var fetchImage: @Sendable (_ urlStr: String) async throws -> Data?

  public init(fetchImage: @Sendable @escaping (_ urlStr: String) async throws -> Data?) {
    self.fetchImage = fetchImage
  }
}
