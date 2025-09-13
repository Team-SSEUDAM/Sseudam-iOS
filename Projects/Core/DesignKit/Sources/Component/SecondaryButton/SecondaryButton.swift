//
//  SecondaryButton.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct SecondaryButton<Icon: View>: View {
  
  public enum SecondaryButtonSize {
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
  
  private var title: String
  private var size: SecondaryButtonSize
  private var icon: () -> Icon
  private var state: SecondaryButtonState
  
  private var action: @Sendable () -> Void
  
  @State private var isPressed: Bool = false
  
  public init(
    icon: @escaping () -> Icon = { EmptyView() },
    title: String,
    size: SecondaryButtonSize = .large,
    state: SecondaryButtonState = .normal,
    _ action: @escaping @Sendable () -> Void
  ) {
    self.title = title
    self.size = size
    self.icon = icon
    self.state = state
    self.action = action
  }
  
  public var body: some View {
    content
      .gesture(
        DragGesture(minimumDistance: .Number0)
          .onChanged { _ in isPressed = true }
          .onEnded { _ in
            isPressed = false
            Task { action() }
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
        .font(size.font)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, size.padding.vertical)
    .padding(.horizontal, size.padding.horizontal)
    .contentShape(Rectangle()) // 버튼의 패딩 영역도 터치 가능하게 설정
    .overlay(
      RoundedRectangle(cornerRadius: size.cornerRadius)
        .inset(by: 0.5)
        .stroke(ColorSet.Border.Primary, lineWidth: 1)
    )
    .overlay {
      if isPressed {
        RoundedRectangle(cornerRadius: size.cornerRadius)
          .fill(ColorSet.Component.Pressed)
      }
    }
  }
}
