//
//  CustomTabBarDemo.swift
//  DesignKit
//
//  Created by 조용인 on 6/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

struct CustomTabBarDemo: View {
  
  @State private var selectedTab: TabBarItem = .home
  
  var body: some View {
    VStack {
      Spacer()
      Text("Selected Tab: \(selectedTab.rawValue)")
        .font(.headline)
        .padding()
      Spacer()
      CustomTabBar(
        selectedTab: $selectedTab
      ) { selectedTab = $0 }
    }
    .padding()
  }
}

#Preview {
  CustomTabBarDemo()
}
