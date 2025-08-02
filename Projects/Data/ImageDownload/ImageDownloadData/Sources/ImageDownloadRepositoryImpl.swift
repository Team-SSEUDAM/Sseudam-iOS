//
//  ImageDownloadRepositoryImpl.swift
//
//  ImageDownload
//
//  Created by JiYeon
//

import Foundation
import ImageDownloadDomainInterface
import ImageDownloadDataInterface
import NetworkKit

public extension ImageDownloadRepository {
  static var live: ImageDownloadRepository {
    ImageDownloadRepository(
      fetchImage: { urlStr in
        // 실제 네트워크 작업 구현
        guard let url = URL(string: urlStr) else { return nil }
        let imageDownloader = ImageDownloader()
        return try await imageDownloader.downloadData(from: url)
      }
    )
  }
}
