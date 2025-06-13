//
//  Badge.swift
//  DesignKit
//
//  Created by 조용인 on 6/13/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct Badge<Icon: View>: View {
  
  @Binding public var state: BadgeState
  @Binding public var text: String
  private let icon: (() -> Icon)?
  
  public init(
    text: Binding<String>,
    state: Binding<BadgeState>,
    icon: (() -> Icon)? = nil
  ) {
    self._text = text
    self._state = state
    self.icon = icon
  }
  
  public var body: some View {
    HStack(spacing: .Number2) {
      icon?()
      Text(text)
        .foregroundStyle(state.textColor)
        .font(FontSet.Caption.caption1)
    }
    .padding(.horizontal, .Number8)
    .padding(.vertical, .Number2)
    .background(
      RoundedRectangle(cornerRadius: .Number4)
        .fill(state.backgroundColor)
    )
  }
  
}
