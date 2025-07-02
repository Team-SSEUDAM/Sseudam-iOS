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
    GeometryReader { geo in
      VStack {
        navigationBar
        ScrollViewReader { proxy in
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .Number16) {
              ReportStartView(
                image: .addSpot,
                title: "발견한 쓰레기통을 제보해주세요!",
                description:"쓰담이 아직 모르는 쓰레기통이 있나요?\n제보 시 5쓰담이 적립되며,\n승인되면 15쓰담을 추가 적립받아요.")
              .frame(width: geo.size.width)
              .id(0)
              MoveLocationView(
                store: store.scope(state: \.child.moveLocation, action: \.child.moveLocation)
              )
              .frame(width: geo.size.width)
              .id(1)
              WriteNameView(
                store: store.scope(state: \.child.writeName, action: \.child.writeName)
              )
              .frame(width: geo.size.width)
              .id(2)
              SelectKindView(
                store: store.scope(state: \.child.selectKind, action: \.child.selectKind)
              )
              .frame(width: geo.size.width)
              .id(3)
              SelectPhotoView(
                store: store.scope(state: \.child.selectPhoto, action: \.child.selectPhoto)
              )
              .frame(width: geo.size.width)
              .id(4)
              SpotSuggestionCompleteView(
                image: .addSpot,
                title: "제보가 완료되었어요!",
                description:"심사는 1-2일이 소요되며,\n승인되면 15쓰담을 추가 적립 받아요."
              )
              .frame(width: geo.size.width)
              .id(5)
            }
          }
          .onChange(of: store.currentPage) { prev, next in
            withAnimation { proxy.scrollTo(next, anchor: .center) }
          }
          .scrollDisabled(true)
        }
        nextButton
          .padding(.horizontal, .Number16)
          .padding(.vertical, .Number24)
          .navigationBarBackButtonHidden(true)
      }
    }
    .background(ColorSet.Background.Primary)
    .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
  }
  
  
  
  /// 네비게이션 바
  @ViewBuilder
  private var navigationBar: some View {
    NavigationBar(
      backContent: {
        if !store.isNavigationBarHidden {
          TouchArea(image: .leftChevron) {
            store.send(.backButtonTapped)
          }
        }
      }
    )
    .blockBackToSwipe()
  }
  
  @ViewBuilder
  private var nextButton: some View {
    PrimaryButton(
      title: $store.nextButtonText,
      size: .large,
      state: $store.nextButtonState
    ) {
      if store.currentPage == 4 { store.send(.reportButtonTapped) }
      else { store.send(.nextButtonTapped) }
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


