//
//  ImageDownloadUseCaseImpl.swift
//
//  ImageDownloadDomain
//
//  Created by JiYeon
//

import Foundation
import ImageDownloadDomainInterface

extension ImageDownloadUseCase {
  public static func live(repository: ImageDownloadRepository) -> ImageDownloadUseCase {
    .init { url in
      try await repository.fetchImage(url)
    }
  }
}
