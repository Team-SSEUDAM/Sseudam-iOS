//
//  CustomTabBar.swift
//  Sseudam
//
//  Created by Jiyeon on 6/6/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

// TODO: - DesignSystem에 추가하기
/// 임시 탭바
struct CustomTabBar: View {
  let selectedTab: TabItem
  var onTabSelected: ((TabItem) -> Void)? = nil
  
  var body: some View {
    HStack(spacing: 12) {
      ForEach(TabItem.allCases, id: \.self) { tab in
        TabButton(tab)
      }
    }
    .frame(height: 62)
    .padding(.horizontal, 8)
    
  }
  
  
  @ViewBuilder
  private func TabButton(_ tab: TabItem) -> some View {
    let isActive: Bool = selectedTab == tab
    VStack(spacing: 0) {
      Image(systemName: tab.iconName)
      Text(tab.title)
        .font(.callout)
        .fontWeight(.medium)
    }
    .foregroundStyle(isActive ? .blue : .gray)
    .frame(maxWidth: .infinity)
    .onTapGesture {
      onTabSelected?(tab)
      
    }
  }
  
  func tabSelected(_ action: @escaping (TabItem) -> Void) -> Self {
    var item = self
    item.onTabSelected = action
    return item
  }
}


enum TabItem: String, CaseIterable, Identifiable {
  case home
  case search
  case profile
  
  var id: String { rawValue }
  
  /// 이미지
  var iconName: String {
    switch self {
    case .home:
      return "house.fill"
    case .search:
      return "magnifyingglass"
    case .profile:
      return "person.fill"
    }
  }
  
  /// 탭바 아래에 표시할 텍스트
  var title: String {
    switch self {
    case .home:
      return "홈"
    case .search:
      return "마이펫"
    case .profile:
      return "마이"
    }
  }
}
