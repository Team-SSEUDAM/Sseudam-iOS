//
//  BadgeState.swift
//  DesignKit
//
//  Created by 조용인 on 6/13/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import SwiftUI

public enum BadgeState {
  case primary, error, accent
  
  public var backgroundColor: Color {
    switch self {
    case .primary: return ColorSet.Background.Tertiary
    case .error: return ColorSet.Pink._50
    case .accent: return ColorSet.Background.Accent
    }
  }
  
  public var textColor: Color {
    switch self {
    case .primary: return ColorSet.Text.Secondary
    case .error: return ColorSet.Text.Error
    case .accent: return ColorSet.Text.Accent
    }
  }
}
