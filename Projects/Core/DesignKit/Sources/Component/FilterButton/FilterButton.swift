//
//  FilterButton.swift
//  DesignKit
//
//  Created by Jiyeon on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct FilterButton: View {
  
  var type: FilterButtonType
  var isActive: Bool
  
  public init(type: FilterButtonType, isActive: Bool) {
    self.type = type
    self.isActive = isActive
  }
  
  public var body: some View {
    HStack(alignment: .center, spacing: .Number4) {
      if let icon = type.icon {
        Icon(image: icon, size: .Number16, color: iconColor)
      }
      Text(type.title)
        .font(FontSet.Body.body3)
        .foregroundStyle(textColor)
    }
    .padding(.leading, type.icon == .none ? .Number16 : .Number12)
    .padding(.trailing, .Number16)
    .padding(.vertical, .Number6)
    .background(bgColor)
    .cornerRadius(.Number100)
    .overlay(
      RoundedRectangle(cornerRadius: .Number100)
        .inset(by: 0.5)
        .stroke(borderColor, lineWidth: .Number1)
    )
  }
}
