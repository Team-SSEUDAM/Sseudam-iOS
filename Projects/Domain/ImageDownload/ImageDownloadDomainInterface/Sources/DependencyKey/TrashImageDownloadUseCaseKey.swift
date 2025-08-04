//
//  ImageDownloadDependencyKey.swift
//
//  ImageDownloadDomainInterface
//
//  Created by JiYeon
//

import Foundation
import Dependencies

public enum TrashImageDownloadUseCaseKey: DependencyKey {
  public static var liveValue: TrashImageDownloadUseCase { TrashImageDownloadUseCaseProvider() }
  public static var previewValue: TrashImageDownloadUseCase { TrashImageDownloadUseCaseProvider() }
  public static var testValue: TrashImageDownloadUseCase { TrashImageDownloadUseCaseProvider() }
}

private var TrashImageDownloadUseCaseProvider: () -> TrashImageDownloadUseCase = {
  fatalError("TrashImageDownloadUseCase Dependency not configured")
}

public func TrashImageDownloadUseCaseRegister(
  provider: @escaping () -> TrashImageDownloadUseCase
) {
  TrashImageDownloadUseCaseProvider = provider
}

extension DependencyValues {
  public var ImageDownloadUseCase: TrashImageDownloadUseCase {
    get { self[TrashImageDownloadUseCaseKey.self] }
    set { self[TrashImageDownloadUseCaseKey.self] = newValue }
  }
}
