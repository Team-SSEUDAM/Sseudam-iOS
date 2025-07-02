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
  public var color: Color
  public var backgroundColor: Color
  public var renderingMode: Image.TemplateRenderingMode
  
  public init(
    image: ImageSet,
    size: CGFloat = .Number20,
    renderingMode: Image.TemplateRenderingMode = .original,
    color: Color = ColorSet.Icon.Primary,
    backgroundColor: Color = .clear
  ) {
    self.image = image
    self.size = size
    self.renderingMode = renderingMode
    self.color = color
    self.backgroundColor = backgroundColor
  }
  
  public var body: some View {
    Image(asset: image.swiftUIImage)
      .renderingMode(renderingMode)
      .resizable()
      .scaledToFit()
      .frame(width: size, height: size)
      .foregroundColor(color)
      .background(
        Circle()
          .fill(backgroundColor)
          .frame(width: size, height: size)
      )
  }
}
