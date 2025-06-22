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
import AuthFeature

struct SseudamView: View {
  @Bindable var store: StoreOf<SseudamFeature> = Store(
    initialState: SseudamFeature.State()
  ) {
    SseudamFeature()
  }
  @State var isPresent: Bool = false
  var body: some View {
    
    ZStack {
      switch store.selectedTab {
      case .home:
        HomeRootView(store: store.scope(state: \.homeRoot, action: \.homeRoot))
      case .myPet:
        EmptyView()
      case .myPage:
//        EmptyView()
        VStack {
          Button("로그인") {
            isPresent = true
          }
        }
      }
      VStack {
        Spacer()
        if !store.isTabbarHidden {
          CustomTabBar(
            selectedTab: $store.selectedTab
          ) {
            store.send(.selectTab($0))
          }
        }
      }
      
    }
    .ignoresSafeArea(edges: .bottom)
    .fullScreenCover(isPresented: $isPresent) {
      AuthView(store: store.scope(state: \.auth, action: \.auth))
    }
  }
}

#Preview {
  SseudamView()
}

