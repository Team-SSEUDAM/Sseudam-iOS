//
//  CustomToggleStyle.swift
//  DesignKit
//
//  Created by Jiyeon on 7/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import SwiftUI

public struct CustomToggleStyle: ToggleStyle {
  public func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.label
      ZStack(alignment: configuration.isOn ? .trailing : .leading) {
        RoundedRectangle(cornerRadius: .Number16)
          .frame(width: .Number56, height: .Number32)
          .foregroundColor(configuration.isOn ? ColorSet.Component.Primary : ColorSet.Background.Tertiary)
        
        RoundedRectangle(cornerRadius: .Number16)
          .frame(width: .Number24, height: .Number24)
          .padding(.Number4)
          .foregroundColor(ColorSet.Background.Primary)
          .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
              configuration.$isOn.wrappedValue.toggle()
            }
          }
      }
    }
  }
}

public extension Toggle {
  func customToggleStyle() -> some View {
    self.toggleStyle(CustomToggleStyle())
  }
}
