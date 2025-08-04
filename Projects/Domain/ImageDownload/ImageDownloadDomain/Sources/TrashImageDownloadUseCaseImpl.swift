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

extension TrashImageDownloadUseCase {
  public static func live(repository: ImageDownloadRepository) -> TrashImageDownloadUseCase {
    .init { url, id in
      do {
        let data = try await repository.fetchTrashImageCache(id)
        
        return data
      } catch let error as CacheError {
        switch error {
        case .fileNotFound:
          let data = try await repository.fetchTrashImage(url, id)
          return data
          
        default: throw error
        }
      }
    }
  }
}
