//
//  HomeRootView.swift
//  Sseudam
//
//  Created by Jiyeon on 6/21/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import HomeFeature
import TrashDetailFeature
import VisitedFeature

struct HomeRootView: View {
  
  @Bindable var store: StoreOf<HomeRootFeature>
  
  init(store: StoreOf<HomeRootFeature>) {
    self.store = store
  }
  
  var body: some View {
    HomeView(store: store.scope(state: \.home, action: \.home))
      .bottomSheet(isPresented: $store.isPresentDetail, height: .detailSheetHeight) {
        IfLetStore(store.scope(state: \.trashDetail, action: \.trashDetail)) { store in
          TrashDetailView(store: store)
        }
      }
      .fullScreenCover(item: $store.scope(state: \.modal?.visitedComplete, action: \.modal.visitedComplete)) { store in
        VisitedCompleteView(store: store)
      }
  }
  
}

