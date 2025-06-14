//
//  DesignKitDemo.swift
//  DesignKitDemo
//
//  Created by 조용인 on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

struct DesignKitDemo: View {
  enum Component: String, Identifiable, CaseIterable {
    case button_primary
    case button_secondary
    case icon_button
    case touch_area
    case navigation_bar
    case alert
    case badge
    case snack_bar
    case text_field
    case underline_tab_bar
    case tab_bar
    case category_chip
    case check_box
    case coach_mark
    
    var id: String { rawValue }
    
    @ViewBuilder
    var detailView: some View {
      switch self {
      case .button_primary: PrimaryButtonDemo()
      case .button_secondary: SecondaryButtonDemo()
      case .icon_button: IconButtonDemo()
      case .touch_area: TouchAreaDemo()
      case .navigation_bar: NavigationBarDemo()
      case .alert: AlertDemo()
      case .badge: BadgeDemo()
      case .snack_bar: SnackBarDemo()
      case .text_field: TextField()
      case .underline_tab_bar: UnderlineTabBar()
      case .tab_bar: TabBar()
      case .category_chip: CategoryChip()
      case .check_box: CheckBox()
      case .coach_mark: CoachMark()
      }
    }
  }
  
  var body: some View {
    NavigationStack {
      List(Component.allCases) { component in
        NavigationLink(component.rawValue) {
          component.detailView
        }
      }
      .navigationTitle("DesignKit Components")
    }
  }
  
  
}

#Preview {
  DesignKitDemo()
}
