//
//  PolicyView.swift
//  MyPageFeature
//
//  Created by Jiyeon on 8/16/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

import ComposableArchitecture

public struct PolicyView: View {
  
  let store: StoreOf<PolicyFeature>
  
  public init(store: StoreOf<PolicyFeature>) {
    self.store = store
  }
  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack(spacing: .Number0) {
        NavigationBarView
        if let url = store.type?.url {
          WebView(url: url)
        }
      }
    }
    .navigationBarBackButtonHidden(true)
  }
  
  @ViewBuilder
  private var NavigationBarView: some View {
    NavigationBar(
      backContent: {
        TouchArea(image: .leftChevron, {
          store.send(.pop)
        })
      },
      title: store.type?.title ?? ""
    )
  }
  
}

