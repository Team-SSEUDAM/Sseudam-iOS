//
//  SettingView.swift
//  MyPageFeature
//
//  Created by Jiyeon on 7/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct SettingView: View {
  @Bindable var store: StoreOf<SettingFeature>

  public init(store: StoreOf<SettingFeature>) {
    self.store = store
  }

  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack {
        NavigationBarView
        Spacer()
      }
    }
    .navigationBarBackButtonHidden()
  }
  
  @ViewBuilder
  private var NavigationBarView: some View {
    NavigationBar(
      backContent: {
        TouchArea(image: .leftChevron, {
          store.send(.pop)
        })
      },
      title: "설정"
    )
    .blockBackToSwipe()
    
  }
}
