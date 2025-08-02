//
//  ImageDownloadDependencyKey.swift
//
//  ImageDownloadDomainInterface
//
//  Created by JiYeon
//

import Foundation
import Dependencies

public enum ImageDownloadUseCaseKey: DependencyKey {
  public static var liveValue: ImageDownloadUseCase { ImageDownloadUseCaseProvider() }
  public static var previewValue: ImageDownloadUseCase { ImageDownloadUseCaseProvider() }
  public static var testValue: ImageDownloadUseCase { ImageDownloadUseCaseProvider() }
}

private var ImageDownloadUseCaseProvider: () -> ImageDownloadUseCase = {
  fatalError("ImageDownloadUseCase Dependency not configured")
}

public func ImageDownloadUseCaseRegister(
  provider: @escaping () -> ImageDownloadUseCase
) {
  ImageDownloadUseCaseProvider = provider
}

extension DependencyValues {
  public var ImageDownloadUseCase: ImageDownloadUseCase {
    get { self[ImageDownloadUseCaseKey.self] }
    set { self[ImageDownloadUseCaseKey.self] = newValue }
  }
}
