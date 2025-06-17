//
//  Font+.swift
//  DesignKit
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import SwiftUI

extension DesignKitFontFamily {
  public struct FontSet: Sendable {
    public struct Heading: Sendable {
      public static let heading1 = FontInfo(font: Pretendard.semiBold, size: 24)
      public static let heading2 = FontInfo(font: Pretendard.semiBold, size: 20)
      public static let heading3 = FontInfo(font: Pretendard.semiBold, size: 18)
      public static let heading4 = FontInfo(font: Pretendard.semiBold, size: 16)
    }
    
    public struct Title: Sendable {
      public static let title1 = FontInfo(font: Pretendard.semiBold, size: 20)
      public static let title2 = FontInfo(font: Pretendard.semiBold, size: 18)
      public static let title3 = FontInfo(font: Pretendard.semiBold, size: 16)
      public static let title4 = FontInfo(font: Pretendard.semiBold, size: 14)
      public static let title5 = FontInfo(font: Pretendard.semiBold, size: 12)
    }
    
    public struct Body: Sendable {
      public static let body1 = FontInfo(font: Pretendard.regular, size: 18)
      public static let body2 = FontInfo(font: Pretendard.regular, size: 16)
      public static let body3 = FontInfo(font: Pretendard.medium, size: 14)
    }
    
    public struct Caption: Sendable {
      public static let caption1 = FontInfo(font: Pretendard.medium, size: 12)
      public static let caption2 = FontInfo(font: Pretendard.medium, size: 8)
    }
    
    public struct Label: Sendable {
      public static let label1 = FontInfo(font: Pretendard.semiBold, size: 16)
      public static let label2 = FontInfo(font: Pretendard.semiBold, size: 14)
      public static let label3 = FontInfo(font: Pretendard.semiBold, size: 12)
    }
  }
}

public struct FontInfo: Sendable {
  public let font: Font
  
  public init(font: DesignKitFontConvertible, size: CGFloat) {
    self.font = font.swiftUIFont(size: size)
  }
}
