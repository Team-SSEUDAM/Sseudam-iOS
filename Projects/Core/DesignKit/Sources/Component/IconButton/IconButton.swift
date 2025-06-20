//
//  IconButton.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct IconButton: View {
  
  public var icon: ImageSet
  public var action: @Sendable () async -> Void
  
  @State private var isPressed: Bool = false
  
  public init(
    icon: ImageSet,
    _ action: @escaping @Sendable () async -> Void
  ) {
    self.icon = icon
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
  }
  
  @ViewBuilder
  private var content: some View {
    Circle()
      .fill(ColorSet.Background.Primary)
      .overlay {
        Icon(image: icon, size: .Number28)
      }
      .padding(.Number8)
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
