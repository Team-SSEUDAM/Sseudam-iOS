//
//  IconButton.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct IconButton: View {
  
  public enum ColorType {
    case primary, accent
    
    var background: Color {
      switch self {
      case .primary: return ColorSet.Background.Primary
      case .accent: return ColorSet.Mint._400
      }
    }
    
    var icon: Color {
      switch self {
      case .primary: return ColorSet.Icon.Primary
      case .accent: return ColorSet.Icon.Inverse
      }
    }
  }
  
  public var icon: ImageSet
  public var action: () async -> Void
  private let type: ColorType
  
  @State private var isPressed: Bool = false
  
  public init(
    icon: ImageSet,
    type: ColorType = .primary,
    _ action: @escaping () async -> Void
  ) {
    self.icon = icon
    self.action = action
    self.type = type
  }
  
  public var body: some View {
    content
      .gesture(
        DragGesture(minimumDistance: .Number0)
          .onChanged { _ in isPressed = true }
          .onEnded {
            _ in
            isPressed = false
            Task { @MainActor in await action() }
          }
      )
  }
  
  @ViewBuilder
  private var content: some View {
    Circle()
      .overlay {
        Icon(
          image: icon,
          size: .Number28,
          renderingMode: .template
        )
          .foregroundColor(type.icon)
          .backgroundColor(type.background)
      }
      .padding(.Number8)
      .background(type.background)
      .clipShape(Circle())
      .elevation(cornerRadius: .Number24)
      .overlay {
        if isPressed {
          Circle()
            .fill(ColorSet.Component.Pressed)
        }
      }
      .frame(width: .Number40, height: .Number40)
  }
}
