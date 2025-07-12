//
//  MyPageRootView.swift
//  Sseudam
//
//  Created by Jiyeon on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import AuthFeature
import DesignKit
import MyPageFeature

struct MyPageRootView: View {
  
  @Bindable var store: StoreOf<MyPageRootFeature>
  
  init(store: StoreOf<MyPageRootFeature>) {
    self.store = store
  }
  
  var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      MyPageView(store: store.scope(state: \.mypage, action: \.mypage))
    }
  }
  
}
