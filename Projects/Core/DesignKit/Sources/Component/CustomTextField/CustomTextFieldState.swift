//
//  CustomTextFieldState.swift
//  DesignKit
//
//  Created by 조용인 on 6/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public enum CustomTextFieldState {
  case normal, accent, disabled, error
  
  public var borderColor: Color {
    switch self {
    case .normal: return ColorSet.Border.Secondary
    case .accent: return ColorSet.Border.Accent
    case .disabled: return ColorSet.Border.Secondary
    case .error: return ColorSet.Border.Error
    }
  }
  
  public var textColor: Color {
    switch self {
    case .disabled: return ColorSet.Text.Disabled
    default: return ColorSet.Text.Primary
    }
  }
  
  public var placeholderColor: Color {
    switch self {
    case .disabled: return ColorSet.Text.Disabled
    default: return ColorSet.Text.Tertiary
    }
  }
  
  public var backgroundColor: Color {
    switch self {
    case .disabled: return ColorSet.Component.Disabled
    default: return .clear
    }
  }
}
