//
//  TrashImageCache.swift
//  Cache
//
//  Created by Jiyeon on 8/3/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct TrashImageCacheModel: Codable, Sendable {
  public let imageData: Data
  
  public init(imageData: Data) {
    self.imageData = imageData
  }
}
