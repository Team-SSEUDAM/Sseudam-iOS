//
//  MyPetDetailView.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import DotLottie

public struct MyPetDetailView: View {
  @Bindable var store: StoreOf<MyPetDetailFeature>
  
  public init(store: StoreOf<MyPetDetailFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      navigationBar
      Spacer()
    }
    .background(ColorSet.Background.Primary)
    .navigationBarBackButtonHidden(true)
  }
  
  
  /// 네비게이션 바
  @ViewBuilder
  private var navigationBar: some View {
    NavigationBar(
      backContent: {
        TouchArea(image: .leftChevron) {
          store.send(.backButtonTapped)
        }
      },
      title: "내가 돌본 펫"
    )
  }
}
