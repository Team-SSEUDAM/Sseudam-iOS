//
//  SseudamView.swift
//  Sseudam
//
//  Created by Jiyeon on 6/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import HomeFeature

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
        HomeView(store: store.scope(state: \.home, action: \.home))
      case .search:
        EmptyView()
      case .profile:
        EmptyView()
      }
      Spacer()
      CustomTabBar(selectedTab: store.selectedTab)
        .tabSelected { tab in
          store.send(.selectTab(tab))
        }
    }
  }
}

#Preview {
  SseudamView()
}


