//
//  HomeView.swift
//  HomeFeature
//
//  Created by Jiyeon on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Utility
import UserDefaults
import DesignKit
import ComposableArchitecture

import ReportFeature
import SuggestionFeature

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
        if store.map.researchButtonEnable {
          VStack {
            Spacer()
            ResearchButton {
              store.send((.map(.requestMapBounds(true))))
            }
          }
          .padding(.bottom, (store.isPresentDetail ? bottomSheetHeight : tabbarHeight) + bottomPadding )
        }
        ZStack {
          VStack {
            TopButtonView
            Spacer()
            BottomButtonView
          }
          SnackBarView
            .padding(.bottom, (store.isPresentDetail ? bottomSheetHeight : tabbarHeight) + bottomPadding )
        }
      }
      .ignoresSafeArea(edges: .bottom)
      .onAppear {
        store.send(.onAppear)
      }
    } destination: { store in
      switch store.case {
      case let .reportView(store):
        ReportView(store: store)
      case let .suggestionView(store):
        SuggestionView(store: store)
      }
    }
    .onChange(of: store.path) { oldValue, newValue in
      /// 네비게이션 path의 `newValue`가 0이 되면 탭바는 등장
      if newValue.count == 0 {
        store.send(.delegate(.needToHiddenTabBar(false)))
      }
    }
    .transaction { transaction in
      transaction.disablesAnimations = false
    }
  }
  
  @ViewBuilder
  private var MapView: some View {
    MapViewRepresentable(
      lastCameraPosition: $store.location.lastCameraPosition,
      userLocation: $store.location.point,
      requestMapBounds: $store.map.requestMapBounds,
      trashItems: $store.map.trashItems,
      isMapMove: $store.map.researchButtonEnable,
      isNeedDeleteMarker: $store.map.isNeedDeleteMarker
    )
    .onReceiveMapBounds {
      store.send(.map(.fetchTrashItems($0)))
    }
    .markerTapped { id in
      store.send(.map(.markerTapped(id)))
    }
  }
  
  @ViewBuilder
  private var SnackBarView: some View {
    SnackBar(message: $store.toastMessage) {
      store.send(.showToastMessage(nil))
    }
    .padding(.horizontal, .Number16)
  }
  
  @ViewBuilder
  private var TopButtonView: some View {
    HStack(spacing: .Number8) {
      if store.isPresentDetail {
        IconButton(icon: .leftChevron) {
          store.send(.removeSuggestionCoachMark)
          store.send(.presentDetailView(false))
          store.send(.map(.deleteActiveMarker))
        }
      }
      TrashFilterView { type in
        store.send(.removeSuggestionCoachMark)
        store.send(.map(.filterTapped(type)))
      }
    }
    .padding(.vertical, .Number8)
    .padding(.leading, .Number16)
  }
  
  /// 하단에 존재하는 버튼
  @ViewBuilder
  private var BottomButtonView: some View {
    HStack(alignment: .bottom) {
      Spacer()
      VStack(alignment: .trailing, spacing: .Number12) {
        if store.isShowSuggestionCoachMark {
          CoachMark(
            text: "내 주변 가로 쓰레기통을\n등록해보세요",
            offset: .Number100
          ) { store.send(.removeSuggestionCoachMark) }
          .position(.bottom)
        }
        SuggestionButton
        UserLocationButton
      }
    }
    .padding(.horizontal, .Number16)
    .padding(
      .bottom,
      (store.isPresentDetail ? bottomSheetHeight : tabbarHeight)+bottomPadding
    )
    .animation(
      .easeInOut(duration: store.isPresentDetail ? 0.3 : 0.13),
      value: store.isPresentDetail
    )
    
  }
  
  @ViewBuilder
  private var UserLocationButton: some View {
    IconButton(icon: .myLocation) {
      store.send(.removeSuggestionCoachMark)
      store.send(.location(.fetchCurrentLocation(true)))
    }
  }
  
  @ViewBuilder
  private var SuggestionButton: some View {
    if !store.isHiddenReportButton {
      IconButton(icon: .addSpot, type: .accent) {
        store.send(.removeSuggestionCoachMark)
        store.send(.suggestionButtonTapped)
      }
    }
  }
  
}
