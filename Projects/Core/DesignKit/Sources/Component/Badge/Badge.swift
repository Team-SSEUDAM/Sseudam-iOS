//
//  Badge.swift
//  DesignKit
//
//  Created by 조용인 on 6/13/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct Badge: View {
  
  @Binding public var text: String
  private let state: BadgeState
  private let icon: ImageSet?
  private let suffix: String?
  
  public init(
    text: Binding<String>,
    state: BadgeState,
    icon: ImageSet? = nil,
    suffix: String? = nil
  ) {
    self._text = text
    self.state = state
    self.icon = icon
    self.suffix = suffix
  }
  
  public var body: some View {
    HStack(spacing: .Number2) {
      if let icon {
        Icon(
          image: icon,
          size: .Number16
        )
        .foregroundColor(state.textColor)
      }
      if let suffix {
        HStack(spacing: 0) {
          Text(text)
            .lineLimit(1)
            .truncationMode(.tail)
            .layoutPriority(0)
          Text(suffix)
            .lineLimit(1)
            .layoutPriority(1)
        }
        .foregroundStyle(state.textColor)
        .font(FontSet.Caption.caption1)
      } else {
        Text(text)
          .foregroundStyle(state.textColor)
          .font(FontSet.Caption.caption1)
      }
    }
    .padding(.horizontal, .Number8)
    .padding(.vertical, .Number2)
    .background(
      RoundedRectangle(cornerRadius: .Number4)
        .fill(state.backgroundColor)
    )
  }
  
}
