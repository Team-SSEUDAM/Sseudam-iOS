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
        Spacer()
        HStack {
          Spacer()
          UserLocationButton
        }
      }
      
    }
    .onAppear {
      store.send(.onAppear)
    }
    .task {
      for await _ in LocationService.shared.userLocationStream {
        store.send(.location(.moveUserLocation))
      }
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
    .padding(.trailing, 16)
    .padding(.bottom, 12)
  
  }
  
  @ViewBuilder
  private var MapView: some View {
    MapViewRepresentable(
      userLocation: $store.location.point,
      requestMapBounds: $store.requestMapBounds,
      trashItems: $store.trashItems
    )
    .onReceiveMapBounds {
      store.send(.fetchTrashItems($0))
    }
    .markerTapped { id in
      print("marker tapped: \(id)")
    }
  }
  
}


