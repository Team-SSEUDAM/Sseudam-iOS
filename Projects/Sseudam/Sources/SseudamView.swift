//
//  SseudamView.swift
//  Sseudam
//
//  Created by Jiyeon on 6/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct SseudamView: View {
  @Bindable var store: StoreOf<SseudamReducer> = Store(
    initialState: SseudamReducer.State()
  ) {
    SseudamReducer()
  }
  
  var body: some View {
    VStack {
      Group {
        switch store.selectedTab {
        case .home:
          EmptyView()
        case .search:
          EmptyView()
        case .profile:
          EmptyView()
        }
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

