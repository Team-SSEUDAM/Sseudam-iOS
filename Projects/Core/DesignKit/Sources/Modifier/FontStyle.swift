//
//  FontStyle.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

private struct FontStyleModifier: ViewModifier {
  let font: FontInfo
  
  func body(content: Content) -> some View {
    content
      .font(font.font)
      .lineSpacing(font.lineheight*0.7)
      .padding(.vertical, (font.lineheight / 2) * 0.6)
  }
}

extension View {
  public func font(_ font: FontInfo) -> some View {
    self.modifier(FontStyleModifier(font: font))
  }
}

