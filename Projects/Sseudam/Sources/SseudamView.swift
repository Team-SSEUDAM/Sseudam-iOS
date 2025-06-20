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
import HomeFeature
import TrashDetailFeature

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
      case .myPet:
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
    .bottomSheet(isPresented: $store.isPresentDetail, height: 177) {
      IfLetStore(store.scope(state: \.trashDetail, action: \.trashDetail)) { store in
        TrashDetailView(store: store)
      }
    }
  }
}

#Preview {
  SseudamView()
}

