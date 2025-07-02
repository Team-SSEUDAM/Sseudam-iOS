//
//  PrimaryButtonDemo.swift
//  DesignKit
//
//  Created by 조용인 on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

struct PrimaryButtonDemo: View {
  
  @State private var buttonState: PrimaryButtonState = .normal
  @State private var disabledButtonState: PrimaryButtonState = .normal
  @State private var errorButtonState: PrimaryButtonState = .normal
  
  var body: some View {
    List {
      Section("일반 텍스트 버튼") {
        PrimaryButton(
          title: .constant("Label"),
          size: .large,
          state: $buttonState
        ) {
          print("Button Clicked")
        }
        
        PrimaryButton(
          title: .constant("Label"),
          size: .medium,
          state: $buttonState
        ) {
          print("Button Clicked")
        }
        
        PrimaryButton(
          title: .constant("Action"),
          size: .medium,
          state: $buttonState
        ) {
          print("Button Clicked")
        }
      }
      
      Section("아이콘 버튼") {
        PrimaryButton(
          icon: {
            Icon(image: .addSpot, size: .Number20)
              .foregroundColor(ColorSet.Icon.Inverse)
          },
          title: .constant("Label"),
          size: .large,
          state: $buttonState
        ) {
          print("Button Clicked")
        }
        
        PrimaryButton(
          icon: {
            Icon(image: .addSpot, size: .Number16)
              .foregroundColor(ColorSet.Icon.Inverse)
          },
          title: .constant("Label"),
          size: .medium,
          state: .constant(.normal)
        ) {
          
          print("Button Clicked")
        }
      }
      
      Section("비활성화 버튼") {
        PrimaryButton(
          title: .constant("Label"),
          size: .large,
          state: $disabledButtonState
        ) {
          disabledButtonState = .disabled
        }
        
        PrimaryButton(
          icon: {
            Icon(image: .addSpot, size: .Number20)
              .foregroundColor(ColorSet.Icon.Inverse)
          },
          title: .constant("Label"),
          size: .large,
          state: .constant(.disabled)
        ) {
          print("Button Clicked")
        }
      }
      
      Section("에러 버튼") {
        PrimaryButton(
          title: .constant("Label"),
          size: .large,
          state: .constant(.error)
        ) {
          print("Button Clicked")
        }
        
        PrimaryButton(
          icon: {
            Icon(image: .addSpot, size: .Number20)
              .foregroundColor(ColorSet.Icon.Inverse)
          },
          title: .constant("Label"),
          size: .large,
          state: $errorButtonState
        ) {
          errorButtonState = .error
        }
      }
    }
  }
}

#Preview {
  PrimaryButtonDemo()
}
