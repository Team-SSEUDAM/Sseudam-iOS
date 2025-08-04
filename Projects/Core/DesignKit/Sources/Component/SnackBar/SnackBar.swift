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
  @Binding var attributedMessage: AttributedString?
  @State private var showSlideAnimation = false
  @State private var isVisible = false
  @State private var isSliding = false
  @State private var boxOpacity: Double = 1
  @State private var currentTask: Task<Void, Never>? = nil
  
  private var buttonLabel: String?
  public var action: @Sendable () async -> Void
  
  public init(
    message: Binding<String?>,
    buttonLabel: String? = nil,
    _ action: @escaping @Sendable () async -> Void
  ) {
    self._message = message
    self._attributedMessage = .constant(nil)
    self.buttonLabel = buttonLabel
    self.action = action
  }
  
  public init(
    attributedMessage: Binding<AttributedString?>,
    buttonLabel: String? = nil,
    _ action: @escaping @Sendable () async -> Void
  ) {
    self._message = .constant(nil)
    self._attributedMessage = attributedMessage
    self.buttonLabel = buttonLabel
    self.action = action
  }
  
  public var body: some View {
    VStack {
      Spacer()
      if isVisible {
        HStack(alignment: .bottom, spacing: 8) {
          if let attributedMessage {
            Text(attributedMessage)
              .font(FontSet.Body.body2)
              .lineLimit(nil)
              .fixedSize(horizontal: false, vertical: true)
          } else if let message {
            Text(message)
              .font(FontSet.Body.body2)
              .foregroundStyle(ColorSet.Text.Inverse)
              .lineLimit(nil)
              .fixedSize(horizontal: false, vertical: true)
          }
          
          Spacer()
          if let buttonLabel {
            Button { Task { await action() } } label: {
              Text(buttonLabel)
                .font(FontSet.Label.label1)
                .foregroundStyle(ColorSet.Text.InverseAccent)
                .padding(.horizontal, .Number8)
            }
          }
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity)
        .padding(.vertical, .Number12)
        .padding(.horizontal, .Number16)
        .background(
          RoundedRectangle(cornerRadius: .Number10)
            .fill(ColorSet.Background.Inverse)
        )
        .fixedSize(horizontal: false, vertical: true)
        .frame(height: showSlideAnimation ? nil : 0)
      }
    }
    .offset(y: showSlideAnimation ? 0 : 30)
    .opacity(showSlideAnimation ? 1 : 0)
    .animation(.easeInOut(duration: 0.4), value: isVisible)
    .onChange(of: message) {
      showToastIfNeeded()
    }
    .onChange(of: attributedMessage) {
      showToastIfNeeded()
    }
    
  }
  
  private func showToastIfNeeded() {
    guard (message != nil && !message!.isEmpty) || attributedMessage != nil else { return }
    currentTask?.cancel()
    currentTask = Task {
      isVisible = true
      withAnimation {
        showSlideAnimation = true
      }
      
      try? await Task.sleep(for: .seconds(1.6))
      
      withAnimation{
        showSlideAnimation = false
      }
      
      try? await Task.sleep(for: .seconds(0.3))
      isVisible = false
      self.message = nil
      self.attributedMessage = nil
    }
  }
}
