//
//  SnackBar.swift
//  DesignKit
//
//  Created by 조용인 on 6/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct SnackBar: View {
  
  @Binding var message: String?
  @State private var isVisible = false
  @State private var boxOpacity: Double = 1
  
  private var buttonLabel: String?
  var action: (() async -> Void)?
  
  public init(
    message: Binding<String?>,
    buttonLabel: String? = nil,
    _ action: (() async -> Void)? = nil
  ) {
    self._message = message
    self.buttonLabel = buttonLabel
    self.action = action
  }
  
  public var body: some View {
    VStack {
      Spacer()
      if isVisible, let message {
        ZStack(alignment: .bottomLeading) {
          RoundedRectangle(cornerRadius: .Number10)
            .fill(ColorSet.Background.Inverse)
            .frame(height: .Number48)
            .frame(maxWidth: .infinity)
          HStack {
            Text(message)
              .font(FontSet.Body.body2)
              .foregroundStyle(ColorSet.Text.Inverse)
              .frame(maxWidth: .infinity, alignment: .leading)
            if let buttonLabel, let action {
              Button { Task { @MainActor in await action() } }
              label: {
                Text(buttonLabel)
                  .font(FontSet.Label.label1)
                  .foregroundStyle(ColorSet.Text.InverseAccent)
                  .padding(.horizontal, .Number8)
              }
            }
          }
          .padding(.vertical, .Number12)
          .padding(.leading, .Number16)
          .padding(.trailing, .Number12)
        }
        .opacity(boxOpacity)
        .padding(.Number16)
        .clipped()
      }
    }
    .onChange(of: message) {
      showToastIfNeeded()
    }
  }
  
  private func showToastIfNeeded() {
    guard let message = message, !message.isEmpty else { return }
    Task {
      boxOpacity = 1
      isVisible = true
      
      // 사라질 때: 전체 박스와 텍스트 페이드아웃
      try? await Task.sleep(for: .seconds(1.6))
      withAnimation(.easeInOut(duration: 0.2)) {
        boxOpacity = 0
      }
      
      try? await Task.sleep(for: .seconds(0.2))
      isVisible = false
      self.message = nil
      
    }
  }
}
