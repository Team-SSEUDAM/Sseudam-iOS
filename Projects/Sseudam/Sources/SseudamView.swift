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
import MyPetFeature
import TrashDetailFeature
import AuthFeature
import UserDefaults
import AttendanceFeature

struct SseudamView: View {
  @Bindable var store: StoreOf<SseudamFeature> = Store(
    initialState: SseudamFeature.State()
  ) {
    SseudamFeature()
  }
  
  init() {
    UITabBar.appearance().isHidden = true
  }
  
  var body: some View {
    
    ZStack(alignment: .bottom) {
      TabView(selection: $store.selectedTab) {
        HomeRootView(store: store.scope(state: \.homeRoot, action: \.homeRoot))
          .tag(TabBarItem.home)
        MyPetRootView(store: store.scope(state: \.myPetRoot, action: \.myPetRoot))
          .tag(TabBarItem.myPet)
        MyPageRootView(store: store.scope(state: \.mypageRoot, action: \.mypageRoot))
          .tag(TabBarItem.myPage)
      }
      VStack {
        Spacer()
        if !store.isTabbarHidden {
          CustomTabBar(selectedTab: $store.selectedTab) {
            store.send(.selectTab($0))
          }
          
        }
      }
      if let alert =  store.presentAlert {
        Alert(
          type: alert,
          isErrorType: alert.isErrorType,
          closeAction: {
            Task { @MainActor in
              store.send(.closeAlertAction)
            }
          },
          acceptAction: {
            Task { @MainActor in
              store.send(.acceptAlertAction)
            }
          }
        )
      }
    }
    .onAppear {
      store.send(.onAppear)
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
    .fullScreenCover(item: $store.scope(state: \.modal?.attendance, action: \.modal.attendance)) { store in
      AttendanceView(store: store)
    }
    .transaction { transaction in
      transaction.disablesAnimations = true
    }
  }
  
}

#Preview {
  SseudamView()
}

