//
//  CategoryButton.swift
//  DesignKit
//
//  Created by 조용인 on 6/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct CategoryButton: View {
  
  @Binding public var state: CategoryButtonState
  
  private let text: String
  private let icon: ImageSet?
  private let action: @Sendable () async -> Void
  
  public init(
    text: String,
    state: Binding<CategoryButtonState>,
    icon: ImageSet? = nil,
    _ action: @escaping @Sendable () async -> Void
  ) {
    self.text = text
    self._state = state
    self.icon = icon
    self.action = action
  }
  
  public var body: some View {
    contentView()
      .onTapGesture {
        Task {
          state = state == .normal ? .selected : .normal
          await action()
        }
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
        .fill(state.backgroundColor)
    )
  }
}
