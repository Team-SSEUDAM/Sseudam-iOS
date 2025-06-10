//
//  PrimaryButtonState.swift
//  DesignKit
//
//  Created by 조용인 on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public enum PrimaryButtonState {
  case normal, disabled, error
  
  public var backgroundColor: Color {
    switch self {
    case .normal: return ColorSet.Component.Primary
    case .disabled: return ColorSet.Component.Disabled
    case .error: return ColorSet.Component.Error
    }
  }
  
  public var textColor: Color {
    switch self {
    case .disabled: return ColorSet.Text.Disabled
    default: return ColorSet.Text.Inverse
    }
  }
}
