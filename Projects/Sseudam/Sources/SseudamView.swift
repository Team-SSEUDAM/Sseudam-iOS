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
import Utility
import HomeFeature
import MyPetFeature
import TrashDetailFeature
import AuthFeature
import UserDefaults
import AttendanceFeature
import LevelUpFeature

struct SseudamView: View {
  @Bindable var store: StoreOf<SseudamFeature>
  
  @Environment(\.scenePhase) var scenePhase
  
  public init(store: StoreOf<SseudamFeature>) {
    self.store = store
    UITabBar.appearance().isHidden = true
  }
  
  var body: some View {
    
    contents
      .onChange(of: scenePhase) { _, newPhase in
        switch newPhase {
        case .active:
          store.send(.scenePhaseChanged(.active))
        case .background:
          store.send(.scenePhaseChanged(.background))
        default: break
        }
      }
      .onAppear {
        store.send(.onAppear)
      }
      .task {
        for await city in LocationService.shared.cityUpdateStream {
          guard let city else { continue }
          store.send(.userLocationChanged(city))
        }
      }
      .fullScreenCover(item: $store.scope(state: \.authFlow?.modal?.login, action: \.authFlow.modal.login)) { store in
        LoginView(store: store)
      }
      .fullScreenCover(item: $store.scope(state: \.authFlow?.modal?.signUp, action: \.authFlow.modal.signUp)) { store in
        NickNameInputView(store: store)
      }
      .fullScreenCover(item: $store.scope(state: \.authFlow?.modal?.complete, action: \.authFlow.modal.complete)) { store in
        SignUpCompleteView(store: store)
      }
      .fullScreenCover(item: $store.scope(state: \.userEntry?.modal?.attendance, action: \.userEntry.modal.attendance)) { store in
        AttendanceView(store: store)
      }
      .fullScreenCover(item: $store.scope(state: \.userEntry?.modal?.levelUp, action: \.userEntry.modal.levelUp)) { store in
        LevelUpView(store: store)
      }
      
  }
  
  @ViewBuilder
  var contents: some View {
    ZStack(alignment: .bottom) {
      TabView(selection: $store.selectedTab) {
        HomeRootView(store: store.scope(state: \.homeRoot, action: \.homeRoot))
          .tag(TabBarItem.home)
        MyPetRootView(store: store.scope(state: \.myPetRoot, action: \.myPetRoot))
          .tag(TabBarItem.myPet)
        NotificationRootView(store: store.scope(state: \.notificationRoot, action: \.notificationRoot))
          .tag(TabBarItem.notification)
        MyPageRootView(store: store.scope(state: \.mypageRoot, action: \.mypageRoot))
          .tag(TabBarItem.myPage).transaction { transaction in
            transaction.disablesAnimations = true
          }
      }
      TabBar
      AlertView
    }
    .ignoresSafeArea(edges: .bottom)
    .transaction { transaction in
      transaction.disablesAnimations = true
    }
  }
  
  @ViewBuilder
  var TabBar: some View {
    VStack {
      Spacer()
      if !store.isTabbarHidden {
        CustomTabBar(selectedTab: $store.selectedTab) {
          store.send(.selectTab($0))
        }
        
      }
    }
  }
  
  @ViewBuilder
  var AlertView: some View {
    if let alert =  store.presentAlert {
      Alert(
        type: alert,
        isErrorType: alert.isErrorType,
        isSingleButton: alert.isSingleButton,
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
  
}
