//
//  Icon.swift
//  DesignKit
//
//  Created by 조용인 on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct Icon: View {
  
  public var image: ImageSet
  public var size: CGFloat
  public var color: Color = ColorSet.Icon.Primary
  
  public init(
    image: ImageSet,
    size: CGFloat = .Number20
  ) {
    self.image = image
    self.size = size
  }
  
  public var body: some View {
    Image(asset: image.swiftUIImage)
      .renderingMode(.template)
      .resizable()
      .scaledToFit()
      .frame(width: size, height: size)
      .foregroundColor(color)
  }
}
