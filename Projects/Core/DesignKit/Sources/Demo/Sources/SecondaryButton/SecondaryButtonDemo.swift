//
//  SecondaryButtonDemo.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

struct SecondaryButtonDemo: View {
  
  @State private var buttonState: SecondaryButtonState = .normal
  @State private var disabledState: SecondaryButtonState = .normal
  
  var body: some View {
    List {
      Section("일반 텍스트 버튼") {
        SecondaryButton(
          title: .constant("Label"),
          state: .constant(buttonState)
        ) {
          print("Button Clicked")
        }
        
        SecondaryButton(
          title: .constant("Label"),
          size: .medium,
          state: .constant(buttonState)
        ) {
          print("Button Clicked")
        }
        
        SecondaryButton(
          title: .constant("Action"),
          size: .medium,
          state: .constant(buttonState)
        ) {
          print("Action Clicked")
        }
      }
      
      Section("아이콘 버튼") {
        SecondaryButton(
          icon: {
            Icon(image: .addSpot, size: .Number20)
              .foregroundColor(ColorSet.Icon.Inverse)
          },
          title: .constant("Label"),
          state: .constant(buttonState)
        ) {
          print("Button Clicked")
        }
        
        SecondaryButton(
          icon: {
            Icon(image: .addSpot, size: .Number16)
              .foregroundColor(ColorSet.Icon.Inverse)
          },
          title: .constant("Label"),
          size: .medium,
          state: .constant(buttonState)
        ) {
          print("Button Clicked")
        }
      }
      
      Section("비활성화 버튼") {
        SecondaryButton(
          title: .constant("Label"),
          state: .constant(disabledState)
        ) {
          disabledState = .disabled
        }
        
        SecondaryButton(
          icon: {
            Icon(image: .addSpot, size: .Number20)
              .foregroundColor(ColorSet.Icon.Inverse)
          },
          title: .constant("Label"),
          state: .constant(.disabled)
        ) {
          print("Button Clicked")
        }
      }
    }
  }
}

#Preview {
  SecondaryButtonDemo()
}
