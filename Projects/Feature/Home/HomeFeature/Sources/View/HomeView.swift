//
//  HomeView.swift
//  HomeFeature
//
//  Created by Jiyeon on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Utility
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
        FilterView
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
      isMapMove: $store.researchButtonEnable
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
  private var FilterView: some View {
    // TODO: - 임시 필터 버튼, 변경 필요
    HStack(spacing: 8) {
      Button {
        store.send(.filterTapped(nil))
      } label: {
        Text("전체")
      }
      Button {
        store.send(.filterTapped(.general))
      } label: {
        Text("일반쓰레기")
      }
      Button {
        store.send(.filterTapped(.recycle))
      } label: {
        Text("재활용쓰레기")
      }
      Spacer()
    }
    .frame(height: 33, alignment: .leading)
  }
  
  /// 하단에 존재하는 버튼
  @ViewBuilder
  private var BottomButtonView: some View {
    HStack {
      Spacer()
        .frame(width: 40, height: 40)
      Spacer()
      ResearchButton
      Spacer()
      UserLocationButton
    }
    .padding(.horizontal, 16)
    .padding(.bottom, store.isPresentDetail ? (197-62+12) : 12)
    .animation(.easeInOut(duration: 0.25), value: store.isPresentDetail)
  }
  
  /// 현위치 재검색 버튼
  @ViewBuilder
  private var ResearchButton: some View {
    // TODO: - 임시 재검색 버튼, 변경 필요
    if store.state.researchButtonEnable {
      Button {
        store.send(.requestMapBounds(true))
      } label: {
        RoundedRectangle(cornerRadius: 15)
          .fill(.brown)
      }
      .frame(width: 150, height: 33)
    }
  }
  
  @ViewBuilder
  private var UserLocationButton: some View {
    // TODO: - 임시 버튼, 변경 필요
    Button {
      store.send(.location(.fetchUserLocation))
    } label: {
      Circle()
        .fill(.blue)
        .frame(width: 40, height: 40)
    }
  }
  
}
