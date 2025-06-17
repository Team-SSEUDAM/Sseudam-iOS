//
//  ChipBoxButton.swift
//  DesignKit
//
//  Created by 조용인 on 6/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct ChipBoxButton: View {
  
  @Binding public var state: ChipBoxButtonState
  @Binding public var text: String
  
  private let icon: ImageSet
  private let action: @Sendable () async -> Void
  
  public init(
    text: Binding<String>,
    state: Binding<ChipBoxButtonState>,
    icon: ImageSet,
    _ action: @escaping @Sendable () async -> Void
  ) {
    self._text = text
    self._state = state
    self.icon = icon
    self.action = action
  }
  
  public var body: some View {
    contentView()
      .onTapGesture {
        Task { await action() }
      }
      
  }
  
  @ViewBuilder
  private func contentView() -> some View {
    HStack(spacing: .Number6) {
      Icon(
        image: icon,
        size: .Number24
      )
      .foregroundColor(state.iconColor)
      Text(text)
        .foregroundStyle(state.textColor)
        .font(FontSet.Body.body3)
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .Number48)
    .padding(.horizontal, .Number16)
    .padding(.vertical, .Number12)
    .background(
      RoundedRectangle(cornerRadius: .Number8)
        .fill(state.backgroundColor)
        .overlay{
          RoundedRectangle(cornerRadius: .Number8)
            .inset(by: 0.5)
            .stroke(state.borderColor, lineWidth: 1)
        }
    )
  }
}

#Preview {
  ChipBoxButton(
    text: .constant("Chip Box Button"),
    state: .constant(.selected),
    icon: .addSpot
  ) {
    print("Chip Box Button tapped")
  }
  .padding()
}
