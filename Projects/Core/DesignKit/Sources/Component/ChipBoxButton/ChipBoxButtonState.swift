//
//  ChipBoxButtonState.swift
//  DesignKit
//
//  Created by 조용인 on 6/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public enum ChipBoxButtonState {
  case normal, selected
  
  public var backgroundColor: Color {
    switch self {
    case .normal: return ColorSet.Background.Primary
    case .selected: return ColorSet.Background.Accent
    }
  }
  
  public var textColor: Color {
    switch self {
    case .normal: return ColorSet.Text.Primary
    case .selected: return ColorSet.Text.Accent
    }
  }
  
  public var borderColor: Color {
    switch self {
    case .normal: return ColorSet.Border.Primary
    case .selected: return ColorSet.Border.Accent
    }
  }
  
  public var iconColor: Color {
    switch self {
    case .normal: return ColorSet.Icon.Primary
    case .selected: return ColorSet.Icon.Accent
    }
  }
}

