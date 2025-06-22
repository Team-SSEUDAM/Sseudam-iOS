//
//  TextFieldDemo.swift
//  DesignKit
//
//  Created by 조용인 on 6/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI


struct TextFieldDemo: View {
  @State private var text: String = ""
  @State private var state: CustomTextFieldState = .normal
  
  var body: some View {
    VStack {
      HStack {
        Button("Toggle") {
          text += "#"
          state = .accent
        }
        Button("Reset") {
          text = text.isEmpty ? "12334" : ""
          state = .normal
        }
        Button("Error") {
          text = ""
          state = .error
        }
        .foregroundStyle(ColorSet.Text.Error)
        Button("Disable") {
          state = .disabled
        }
      }
      CustomTextField(
        placeholder: "이건 플레이스홀더입니다",
        text: $text,
        state: $state,
        injectedFocus: .constant(false)
      ) {
        Text("이건 설명입니다")
      }
    }
  }
}

#Preview {
  TextFieldDemo()
}
