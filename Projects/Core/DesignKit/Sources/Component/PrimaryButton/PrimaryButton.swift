//
//  PrimaryButton.swift
//  DesignKit
//
//  Created by 조용인 on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct PrimaryButton<Icon: View>: View {
  
  public enum PrimaryButtonSize {
    case large, medium
    
    public var cornerRadius: CGFloat {
      switch self {
      case .large: return .Number10
      case .medium: return .Number8
      }
    }
    
    public var padding: (vertical: CGFloat, horizontal: CGFloat) {
      switch self {
      case .large: return (.Number12, .Number28)
      case .medium: return (.Number10, .Number20)
      }
    }
    
    public var font: FontInfo {
      switch self {
      case .large: return FontSet.Label.label1
      case .medium: return FontSet.Label.label2
      }
    }
  }
  
  public var title: String
  public var size: PrimaryButtonSize
  public var icon: () -> Icon
  
  public var action: @Sendable () async -> Void
  
  @Binding public var state: PrimaryButtonState
  @State private var isPressed: Bool = false
  
  public init(
    icon: @escaping () -> Icon = { EmptyView() },
    title: String,
    size: PrimaryButtonSize = .large,
    state: Binding<PrimaryButtonState> = .constant(.normal),
    _ action: @escaping @Sendable () async -> Void
  ) {
    self.title = title
    self.size = size
    self.icon = icon
    self._state = state
    self.action = action
  }
  
  public var body: some View {
    content
      .gesture(
        DragGesture(minimumDistance: .Number0)
          .onChanged { _ in isPressed = true }
          .onEnded {
            _ in
            isPressed = false
            Task { await action() }
          }
      )
      .disabled(state == .disabled)
  }
  
  @ViewBuilder
  private var content: some View {
    HStack(spacing: .Number6) {
      icon()
      Text(title)
        .foregroundColor(state.textColor)
        .font(size.font.font)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, size.padding.vertical)
    .background(
      RoundedRectangle(cornerRadius: size.cornerRadius)
        .fill(state.backgroundColor)
    )
    .overlay {
      if isPressed {
        RoundedRectangle(cornerRadius: size.cornerRadius)
          .fill(ColorSet.Component.Pressed)
      }
    }
  }
}
