//
//  UIImage+.swift
//  Utility
//
//  Created by Jiyeon on 8/3/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import UIKit
import ImageIO

public extension UIImage {
  static func downsampled(
    from data: Data,
    to pointSize: CGSize,
    scale: CGFloat = UIScreen.main.scale
  ) -> UIImage? {
    let options: [CFString: Any] = [
      kCGImageSourceShouldCache: false
    ]
    
    guard let source = CGImageSourceCreateWithData(data as CFData, options as CFDictionary) else {
      return nil
    }
    
    let maxDimension = max(pointSize.width, pointSize.height) * scale
    
    let downsampleOptions: [CFString: Any] = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: maxDimension
    ]
    
    guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions as CFDictionary) else {
      return nil
    }
    
    return UIImage(cgImage: cgImage)
  }
  
  static func downsampledAsync(from data: Data, to pointSize: CGSize) async -> UIImage? {
      await Task.detached(priority: .userInitiated) {
        UIImage.downsampled(from: data, to: pointSize)
      }.value
    }
}
