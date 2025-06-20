//
//  FilterButton+.swift
//  DesignKit
//
//  Created by Jiyeon on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

extension FilterButton {
  
  var bgColor: Color {
    isActive ? ColorSet.Background.Accent : ColorSet.Background.Primary
  }
  
  var borderColor: Color {
    isActive ? ColorSet.Border.Accent : ColorSet.Border.Primary
  }
  
  var textColor: Color {
    isActive ? ColorSet.Text.Accent : ColorSet.Text.Primary
  }
  
  var iconColor: Color {
    isActive ? ColorSet.Icon.Accent : ColorSet.Icon.Primary
  }
}
