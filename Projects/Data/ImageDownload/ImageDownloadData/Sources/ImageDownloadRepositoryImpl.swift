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
import Cache
import Utility

public extension ImageDownloadRepository {
  static var live: ImageDownloadRepository {
    ImageDownloadRepository(
      fetchTrashImage: { urlStr, id in
        guard let url = URL(string: urlStr) else { return nil }
        let imageDownloader = ImageDownloader()
        let data = try await imageDownloader.downloadData(from: url)
        
        let cacheKey = ImageCacheKey.trashImage(id: id)
        let cache = try await CacheActor.shared.TRASH_IMAGE_CACHE(id: id)
        let cacheModel = TrashImageCacheModel(imageData: data)
        
        await cache.remove(forKey: cacheKey)
        try await cache.insert(cacheModel, forKey: cacheKey)
        return data
      },
      fetchTrashImageCache: { id in
        let cacheKey = ImageCacheKey.trashImage(id: id)
        let cache = try await CacheActor.shared.TRASH_IMAGE_CACHE(id: id)
        guard let hitData = await cache.value(forKey: cacheKey) else {
          throw CacheError.fileNotFound
        }
        print("📷 FETCH IMAGE FROM CACHE")
        return hitData.imageData
      }
    )
  }
}
