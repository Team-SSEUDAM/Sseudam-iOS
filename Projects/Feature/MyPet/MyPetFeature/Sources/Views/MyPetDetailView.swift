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
      PetHistoryGridView
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
  
  @ViewBuilder
  private var PetHistoryGridView: some View {
    ScrollView {
      LazyVGrid(
        columns: [GridItem(.flexible()), GridItem(.flexible())],
        spacing: .Number12
      ) {
        ForEach(store.catHistoryCard) { record in
          CatHistoryCardCell(record: record)
        }
      }
      .padding(.horizontal, .Number16)
      .padding(.top, .Number16)
    }
    .background(
      LinearGradient(
        gradient: Gradient(
          colors: [
            ColorSet.Background.Primary,
            ColorSet.Background.Tertiary
          ]
        ),
        startPoint: .top,
        endPoint: .bottom
      )
    )
  }
}
