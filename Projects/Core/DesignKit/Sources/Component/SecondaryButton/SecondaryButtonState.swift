//
//  SecondaryButtonState.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

import SwiftUI

public enum SecondaryButtonState {
  case normal, disabled, isLoading
  
  public var backgroundColor: Color {
    switch self {
    case .normal: return ColorSet.Background.Primary
    case .disabled: return ColorSet.Component.Disabled
    case .isLoading: return ColorSet.Background.Primary
    }
  }
  
  public var textColor: Color {
    switch self {
    case .normal: return ColorSet.Text.Primary
    case .disabled: return ColorSet.Text.Disabled
    case .isLoading: return ColorSet.Text.Primary
    }
  }
}
