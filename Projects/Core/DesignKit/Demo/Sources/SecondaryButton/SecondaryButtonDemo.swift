//
//  SecondaryButtonDemo.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

struct SecondaryButtonDemo: View {
  
  @State private var buttonState: SecondaryButtonState = .normal
  @State private var disabledState: SecondaryButtonState = .disabled
  
  var body: some View {
    List {
      Section("일반 텍스트 버튼") {
        SecondaryButton(
          title: "Label",
          size: .large
        )
        
        SecondaryButton(
          title: "Label",
          size: .medium
        )
        
        SecondaryButton(
          title: "Action",
          size: .medium
        )
      }
      
      Section("아이콘 버튼") {
        SecondaryButton(
          icon: {
            Icon(image: .addSpot, size: .Number20)
              .foregroundColor(ColorSet.Icon.Inverse)
          },
          title: "Label",
          size: .large
        )
        
        SecondaryButton(
          icon: {
            Icon(image: .addSpot, size: .Number16)
              .foregroundColor(ColorSet.Icon.Inverse)
          },
          title: "Label",
          size: .medium
        ) {
          print("Button Clicked")
        }
      }
      
      Section("비활성화 버튼") {
        SecondaryButton(
          title: "Label",
          size: .large,
          state: $disabledState
        )
        
        SecondaryButton(
          icon: {
            Icon(image: .addSpot, size: .Number20)
              .foregroundColor(ColorSet.Icon.Inverse)
          },
          title: "Label",
          size: .large,
          state:  $disabledState
        )
      }
    }
  }
}

#Preview {
  SecondaryButtonDemo()
}
