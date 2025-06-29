//
//  PrimaryButtonState.swift
//  DesignKit
//
//  Created by 조용인 on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public enum PrimaryButtonState: Equatable {
  case normal, disabled, error
  case custom(bg: Color, text: Color)
  
  public var backgroundColor: Color {
    switch self {
    case .normal: return ColorSet.Component.Primary
    case .disabled: return ColorSet.Component.Disabled
    case .error: return ColorSet.Component.Error
    case let .custom(bg, _): return bg
    }
  }
  
  public var textColor: Color {
    switch self {
    case .disabled: return ColorSet.Text.Disabled
    case let .custom(_ , text): return text
    default: return ColorSet.Text.Inverse
    }
  }
}
