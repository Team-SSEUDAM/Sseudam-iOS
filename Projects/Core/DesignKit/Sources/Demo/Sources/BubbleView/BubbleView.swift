//
//  BubbleView.swift
//  DesignKit
//
//  Created by 조용인 on 7/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct BubbleView: View {
  private let text: String
  private let font: FontInfo
  private let textColor: Color
  private let backgroundColor: Color
  private let useContentTransition: Bool
  
  public init(
    text: String,
    font: FontInfo = FontSet.Title.title3,
    textColor: Color = ColorSet.Text.Primary,
    backgroundColor: Color = ColorSet.Background.Primary,
    useContentTransition: Bool = true
  ) {
    self.text = text
    self.font = font
    self.textColor = textColor
    self.backgroundColor = backgroundColor
    self.useContentTransition = useContentTransition
  }
  
  public var body: some View {
    Text(text)
      .font(font)
      .foregroundColor(textColor)
      .contentTransition(useContentTransition ? .numericText() : .identity)
      .animation(.easeInOut(duration: 0.3), value: text)
      .padding(.horizontal, .Number16)
      .padding(.vertical, .Number8)
      .clipCorners(.Number20, corners: .allCorners)
      .elevation()
      .animation(.easeInOut(duration: 0.2), value: text)
  }
}
