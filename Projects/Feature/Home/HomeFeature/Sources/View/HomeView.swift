//
//  HomeView.swift
//  HomeFeature
//
//  Created by Jiyeon on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Utility
import DesignKit
import ComposableArchitecture

public struct HomeView: View {
  @Bindable var store: StoreOf<HomeFeature>

  public init(store: StoreOf<HomeFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      MapView
      .ignoresSafeArea()
      VStack {
        TopButtonView
        Spacer()
        BottomButtonView
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
    .task { @MainActor in
      for await _ in LocationService.shared.userLocationStream {
        store.send(.location(.moveUserLocation))
      }
    }
  }
  
  @ViewBuilder
  private var MapView: some View {
    MapViewRepresentable(
      userLocation: $store.location.point,
      requestMapBounds: $store.requestMapBounds,
      trashItems: $store.trashItems,
      isMapMove: $store.researchButtonEnable,
      isNeedDeleteMarker: $store.isNeedDeleteMarker
    )
    .onReceiveMapBounds {
      store.send(.fetchTrashItems($0))
    }
    .markerTapped { id in
      print("marker tapped: ", id ?? "x")
      store.send(.markerTapped(id))
    }
  }
  
  @ViewBuilder
  private var TopButtonView: some View {
    HStack(spacing: .Number8) {
      if store.isPresentDetail {
        IconButton(icon: .leftChevron) {
          Task { @MainActor in
            store.send(.presentDetailView(false))
            store.send(.deleteActiveMarker)
          }
        }
      }
      FilterButtonList { type in
        store.send(.filterTapped(type))
      }
    }
    .padding(.vertical, .Number8)
    .padding(.leading, .Number16)
  }
  
  /// 하단에 존재하는 버튼
  @ViewBuilder
  private var BottomButtonView: some View {
    HStack {
      Spacer()
        .frame(width: .Number40, height: .Number40)
      Spacer()
      ResearchButton
      Spacer()
      UserLocationButton
    }
    .padding(.bottom, store.isPresentDetail ? 177-62+12 : .Number12)
    .padding(.horizontal, .Number16)
    .animation(.easeInOut(duration: 0.25), value: store.isPresentDetail)
  }
  
  /// 현위치 재검색 버튼
  @ViewBuilder
  private var ResearchButton: some View {
    if store.state.researchButtonEnable {
      HStack(alignment: .center, spacing: .Number4) {
        Icon(
          image: .replay,
          size: .Number16,
          color: ColorSet.Icon.Accent
        )
        Text("현 위치에서 재검색")
          .foregroundStyle(ColorSet.Text.Primary)
          .font(FontSet.Body.body3)
      }
      .padding(.leading, .Number12)
      .padding(.trailing, .Number16)
      .padding(.vertical, .Number6)
      .frame(height: 33, alignment: .center)
      .background(ColorSet.Background.Primary)
      .cornerRadius(.Number100)
      .elevation(level: .medium, cornerRadius: .Number100)
    }
  }
  
  @ViewBuilder
  private var UserLocationButton: some View {
    IconButton(icon: .myLocation) {
      Task { @MainActor in
        store.send(.location(.fetchUserLocation))
      }
    }
  }
  
}
