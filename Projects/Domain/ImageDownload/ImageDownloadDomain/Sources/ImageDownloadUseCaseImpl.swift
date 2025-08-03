//
//  ImageDownloadUseCaseImpl.swift
//
//  ImageDownloadDomain
//
//  Created by JiYeon
//

import Foundation
import ImageDownloadDomainInterface
import Utility

extension ImageDownloadUseCase {
  public static func live(repository: ImageDownloadRepository) -> ImageDownloadUseCase {
    .init { url, id in
      do {
        let data = try await repository.fetchImageCache(id)
        
        return data
      } catch let error as CacheError {
        switch error {
        case .fileNotFound:
          let data = try await repository.fetchImage(url, id)
          return data
          
        default: throw error
        }
      }
    }
  }
}
