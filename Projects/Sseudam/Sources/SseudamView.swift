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
import UserDefaults

struct SseudamView: View {
  @Bindable var store: StoreOf<SseudamFeature> = Store(
    initialState: SseudamFeature.State()
  ) {
    SseudamFeature()
  }
  
  var body: some View {
    
    ZStack {
      HomeView
      PetView
      MyPageView
         
      VStack {
        Spacer()
        if !store.isTabbarHidden {
          CustomTabBar(selectedTab: $store.selectedTab) {
            store.send(.selectTab($0))
          }
        }
      }
      
    }
    .ignoresSafeArea(edges: .bottom)
    .fullScreenCover(item: $store.scope(state: \.authFlow?.modal?.login, action: \.authFlow.modal.login)) { store in
      LoginView(store: store)
    }
    .fullScreenCover(item: $store.scope(state: \.authFlow?.modal?.signUp, action: \.authFlow.modal.signUp)) { store in
      NickNameInputView(store: store)
    }
    .fullScreenCover(item: $store.scope(state: \.authFlow?.modal?.complete, action: \.authFlow.modal.complete)) { store in
      SignUpCompleteView(store: store)
    }
    .transaction { transaction in
      transaction.disablesAnimations = true
    }
  }
  
  private var HomeView: some View {
    HomeRootView(store: store.scope(state: \.homeRoot, action: \.homeRoot))
       .opacity(store.selectedTab == .home ? 1 : 0)
       .allowsHitTesting(store.selectedTab == .home)
  }
  
  private var PetView: some View {
    EmptyView()
       .opacity(store.selectedTab == .myPet ? 1 : 0)
       .allowsHitTesting(store.selectedTab == .myPet)
  }
  
  private var MyPageView: some View {
    MyPageRootView(store: store.scope(state: \.mypageRoot, action: \.mypageRoot))
      .opacity(store.selectedTab == .myPage ? 1 : 0)
      .allowsHitTesting(store.selectedTab == .myPage)
  }
  
}

#Preview {
  SseudamView()
}

