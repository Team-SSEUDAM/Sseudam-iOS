//
//  CustomTextField.swift
//  DesignKit
//
//  Created by 조용인 on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//


import SwiftUI

public struct CustomTextField<Subject: View, Description: View>: View {
  
  public let subject: () -> Subject
  public let description: () -> Description
  
  public let placeholder: String
  
  @FocusState private var isFocused: Bool
  
  @Binding public var text: String
  @Binding public var state: CustomTextFieldState
  
  public init(
    _ subject: @escaping () -> Subject = { EmptyView() },
    placeholder: String = "",
    text: Binding<String>,
    state: Binding<CustomTextFieldState>,
    _ description: @escaping () -> Description = { EmptyView() }
  ) {
    self.subject = subject
    self.placeholder = placeholder
    self._text = text
    self._state = state
    self.description = description
    
  }
  
  public var body: some View {
    content
      .disabled(state == .disabled)
  }
  
  @ViewBuilder
  private var content: some View {
    VStack(alignment: .leading, spacing: .Number6) {
      subject()
      TextField(placeholder, text: $text)
        .focused($isFocused)
        .font(FontSet.Body.body2)
        .foregroundColor(state == .disabled ? ColorSet.Text.Tertiary : ColorSet.Text.Primary)
        .padding(.Number12)
        .overlay(
          RoundedRectangle(cornerRadius: .Number10)
          .inset(by: 0.5)
          .stroke(state.borderColor, lineWidth: .Number1)
        )
      description()
        .foregroundStyle(state == .error ? ColorSet.Text.Error : ColorSet.Text.Tertiary)
        .font(FontSet.Body.body3)
    }
  }
}
