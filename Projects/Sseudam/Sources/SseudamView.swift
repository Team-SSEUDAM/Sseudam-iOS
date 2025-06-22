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
  
  var body: some View {
    
    ZStack {
      switch store.selectedTab {
      case .home:
        HomeRootView(store: store.scope(state: \.homeRoot, action: \.homeRoot))
      case .myPet:
        EmptyView()
      case .myPage:
        MyPageRootView(store: store.scope(state: \.mypageRoot, action: \.mypageRoot))
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
    .fullScreenCover(isPresented: $store.isLoginPresent) {
      IfLetStore(store.scope(state: \.login, action: \.login)) { store in
        LoginView(store: store)
      }
      
    }
  }
}

#Preview {
  SseudamView()
}

