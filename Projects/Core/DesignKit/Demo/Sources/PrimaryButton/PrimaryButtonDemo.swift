//
//  PrimaryButtonDemo.swift
//  DesignKit
//
//  Created by 조용인 on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

struct PrimaryButtonDemo: View {
  
  @State private var buttonState: PrimaryButtonState = .normal
  
  var body: some View {
    List {
      Section("일반 텍스트 버튼") {
        PrimaryButton(
          title: "Label",
          size: .large
        )
        
        PrimaryButton(
          title: "Label",
          size: .medium
        )
        
        PrimaryButton(
          title: "Action",
          size: .medium
        )
      }
      
      Section("아이콘 버튼") {
        PrimaryButton(
          icon: {
            Icon(image: .addSpot)
              .size(.large)
              .foregroundColor(ColorSet.Icon.Inverse)
          },
          title: "Label",
          size: .large
        )
        
        PrimaryButton(
          icon: {
            Icon(image: .addSpot)
              .size(.small)
              .foregroundColor(ColorSet.Icon.Inverse)
          },
          title: "Label",
          size: .medium
        ) {
          print("Button Clicked")
        }
      }
      
      Section("비활성화 버튼") {
        PrimaryButton(
          title: "Label",
          size: .large
        )
        
        PrimaryButton(
          icon: {
            Icon(image: .addSpot)
              .size(.large)
              .foregroundColor(ColorSet.Icon.Inverse)
          },
          title: "Label",
          size: .large
        )
      }
      
      Section("에러 버튼") {
        PrimaryButton(
          title: "Label",
          size: .large,
          state: .constant(.error)
        )
        
        PrimaryButton(
          icon: {
            Icon(image: .addSpot)
              .size(.large)
              .foregroundColor(ColorSet.Icon.Inverse)
          },
          title: "Label",
          size: .large,
          state: $buttonState
        ) {
          buttonState = .disabled
        }
      }
    }
  }
}

#Preview {
  PrimaryButtonDemo()
}
