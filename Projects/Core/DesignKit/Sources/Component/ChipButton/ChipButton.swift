//
//  ChipButton.swift
//  DesignKit
//
//  Created by 조용인 on 6/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct ChipButton: View {
  
  @Binding public var state: ChipButtonState
  @Binding public var text: String
  
  private let icon: ImageSet?
  private let action: (() async -> Void)?
  
  public init(
    text: Binding<String>,
    state: Binding<ChipButtonState>,
    icon: ImageSet? = nil,
    _ action: (() async -> Void)? = nil
  ) {
    self._text = text
    self._state = state
    self.icon = icon
    self.action = action
  }
  
  public var body: some View {
    contentView()
      .onTapGesture {
        Task { @MainActor in await action?() }
      }
      
  }
  
  @ViewBuilder
  private func contentView() -> some View {
    HStack(spacing: .Number4) {
      if let icon = icon {
        Icon(
          image: icon,
          size: .Number16
        )
        .foregroundColor(state.iconColor)
      }
      Text(text)
        .foregroundStyle(state.textColor)
        .font(FontSet.Body.body3)
    }
    .foregroundStyle(state.backgroundColor)
    .padding(.horizontal, icon == nil ? .Number16 : .Number12)
    .padding(.vertical, .Number6)
    .background(
      RoundedRectangle(cornerRadius: .Number100)
        .inset(by: 0.5)
        .stroke(state.borderColor, lineWidth: 1)
    )
  }
}
