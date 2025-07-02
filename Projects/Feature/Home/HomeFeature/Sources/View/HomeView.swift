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

import ReportFeature

public struct HomeView: View {
  @Bindable var store: StoreOf<HomeFeature>

  public init(store: StoreOf<HomeFeature>) {
    self.store = store
  }
  
  private let tabbarHeight: CGFloat = 83
  private let bottomSheetHeight: CGFloat = .detailSheetHeight
  private let bottomPadding: CGFloat = .Number12
  
  public var body: some View {
    NavigationStack(
      path: $store.scope(state: \.path, action: \.path)
    ) {
      ZStack {
        MapView
        .ignoresSafeArea()
        VStack {
          TopButtonView
          Spacer()
          SnackBar(message: $store.toastMessage) {
            store.send(.showToastMessage(nil))
          }
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
    } destination: { store in
      switch store.case {
      case let .reportView(store):
        ReportView(store: store)
      }
    }
    .onChange(of: store.path) { oldValue, newValue in
      /// 네비게이션 path의 `newValue`가 0이 되면 탭바는 등장
      if newValue.count == 0 { store.send(.delegate(.needToHiddenTabBar(false))) }
    }
    .transaction { transaction in
      transaction.disablesAnimations = false
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
          store.send(.presentDetailView(false))
          store.send(.deleteActiveMarker)
        }
      }
      TrashFilterView { type in
        store.send(.filterTapped(type))
      }
    }
    .padding(.vertical, .Number8)
    .padding(.leading, .Number16)
  }
  
  /// 하단에 존재하는 버튼
  @ViewBuilder
  private var BottomButtonView: some View {
    VStack {
      HStack {
        Spacer()
        ReportButton
      }
      .padding(.horizontal, .Number16)
      HStack {
        Spacer()
          .frame(width: .Number40, height: .Number40)
        Spacer()
        if store.state.researchButtonEnable {
          ResearchButton {
            store.send(.requestMapBounds(true))
          }
        }
        Spacer()
        UserLocationButton
      }
      .padding(
        .bottom,
        (store.isPresentDetail ? bottomSheetHeight : tabbarHeight)+bottomPadding
      )
      .padding(.horizontal, .Number16)
      .animation(
        .easeInOut(duration: store.isPresentDetail ? 0.3 : 0.13),
        value: store.isPresentDetail
      )
    }
  }
  
  @ViewBuilder
  private var UserLocationButton: some View {
    IconButton(icon: .myLocation) {
      store.send(.location(.fetchUserLocation))
    }
  }
  
  @ViewBuilder
  private var ReportButton: some View {
    IconButton(icon: .addSpot, type: .accent) {
      store.send(.reportButtonTapped)
    }
  }
  
}
