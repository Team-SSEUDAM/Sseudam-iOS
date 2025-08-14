//
//  ResearchButton.swift
//  DesignKit
//
//  Created by Jiyeon on 6/21/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct ResearchButton: View {
  
  private var action: (() async -> Void)? = nil
  
  @State private var isPressed: Bool = false
  
  public init(action: (() async -> Void)?) {
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
            if let action = action {
              Task { @MainActor in
                await action()
              }
            }
          }
      )
  }
  
  @ViewBuilder
  private var content: some View {
    HStack(alignment: .center, spacing: .Number4) {
      Icon(
        image: .replay,
        size: .Number16,
        renderingMode: .template,
        color: ColorSet.Icon.Accent
      )
      Text("현 위치에서 재검색")
        .foregroundStyle(ColorSet.Text.Primary)
        .font(FontSet.Body.body3)
    }
    .padding(.leading, .Number12)
    .padding(.trailing, .Number16)
    .padding(.vertical, .Number6)
    .frame(height: 33, alignment: .center)
    .background(ColorSet.Background.Primary)
    .cornerRadius(.Number100)
    .elevation(level: .medium, cornerRadius: .Number100)
  }
}
