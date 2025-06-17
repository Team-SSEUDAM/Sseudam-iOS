//
//  CustomTabBar.swift
//  DesignKit
//
//  Created by 조용인 on 6/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct CustomTabBar: View {
  
  @Binding var selectedTab: TabBarItem
  var onTabSelected: @Sendable (TabBarItem) async -> Void
  
  public init(
    selectedTab: Binding<TabBarItem>,
    _ onTabSelected: @escaping @Sendable (TabBarItem) async -> Void
  ) {
    self._selectedTab = selectedTab
    self.onTabSelected = onTabSelected
  }
  
  public var body: some View {
    HStack(spacing: 12) {
      ForEach(TabBarItem.allCases, id: \.self) { tab in
        TabButton(tab)
      }
    }
    .padding(.horizontal, .Number8)
  }
  
  @ViewBuilder
  private func TabButton(_ tab: TabBarItem) -> some View {
    let isActive: Bool = selectedTab == tab
    VStack(spacing: 0) {
      Icon(
        image: isActive
        ? tab.tabBarIcons.selected
        : tab.tabBarIcons.unselected,
        size: .Number30
      )
      .foregroundColor(isActive ? ColorSet.Icon.Accent : ColorSet.Icon.Secondary)
      Text(tab.title)
        .font(FontSet.Label.label3)
        .foregroundStyle(isActive ? ColorSet.Text.Accent : ColorSet.Text.Secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: 62)
    .onTapGesture { Task { await onTabSelected(tab) } }
  }
}
