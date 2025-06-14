//
//  SseudamView.swift
//  Sseudam
//
//  Created by Jiyeon on 6/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture

struct SseudamView: View {
  @Bindable var store: StoreOf<SseudamFeature> = Store(
    initialState: SseudamFeature.State()
  ) {
    SseudamFeature()
  }
  
  var body: some View {
    VStack {
      switch store.selectedTab {
      case .home:
        EmptyView()
      case .search:
        EmptyView()
      case .profile:
        EmptyView()
      }
      Spacer()
      CustomTabBar(
        selectedTab: $store.selectedTab
      ) {
        store.send(.selectTab($0))
      }
    }
  }
}

#Preview {
  SseudamView()
}

