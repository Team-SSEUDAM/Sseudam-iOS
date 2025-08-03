//
//  ImageDownloadUseCase.swift
//
//  ImageDownloadDomainInterface
//
//  Created by JiYeon
//

import Foundation

public struct ImageDownloadUseCase {
  public var execute: @Sendable (_ url: String, _ id: Int) async throws -> Data?
  
  public init(execute: @Sendable @escaping (_ url: String, _ id: Int) async throws -> Data?) {
    self.execute = execute
  }
}
