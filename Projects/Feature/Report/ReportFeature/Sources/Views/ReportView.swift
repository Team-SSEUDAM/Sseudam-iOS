//
//  ReportView.swift
//  ReportFeature
//
//  Created by 조용인 on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import DesignKit

public struct ReportView: View {
  @Bindable var store: StoreOf<ReportFeature>
  
  public init(store: StoreOf<ReportFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      navigationBar
      MoveLocationView(store: store.scope(state: \.moveLocation, action: \.moveLocation))
      nextButton
        .padding(.horizontal, .Number16)
        .padding(.vertical, .Number24)
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
          store.send(.backButtonTapped(.pop))
        }
      }
    )
  }
  
  @ViewBuilder
  private var nextButton: some View {
    PrimaryButton(
      title: $store.nextButtonText,
      size: .large,
      state: $store.nextButtonState
    ) {
      print("다음 버튼 클릭")
    }
  }
}

#Preview {
  ReportView(
    store: Store(
      initialState: ReportFeature.State()
    ) {
      ReportFeature()
    }
  )
}


