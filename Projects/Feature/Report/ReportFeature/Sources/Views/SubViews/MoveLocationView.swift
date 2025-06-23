//
//  MoveLocationView.swift
//  ReportFeature
//
//  Created by 조용인 on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Utility
import DesignKit
import ComposableArchitecture

public struct MoveLocationView: View {
  @Bindable var store: StoreOf<MoveLocationFeature>
  
  public init(store: StoreOf<MoveLocationFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: .Number24) {
      VStack(alignment: .leading, spacing: .Number8) {
        Text("지도를 움직여,\n쓰레기통 위치를 지정해주세요")
          .font(FontSet.Heading.heading1)
          .foregroundStyle(ColorSet.Text.Primary)
        Text(store.address)
          .font(FontSet.Body.body3)
          .foregroundStyle(ColorSet.Text.Secondary)
          .multilineTextAlignment(.leading)
      }
      ReportMapViewRepresentable(
        userLocation: $store.userLocation
      )
      .onReceive {
        store.send(.centerChanged($0))
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
    .padding(.horizontal, .Number16)
    .padding(.vertical, .Number24)

  }
}

#Preview {
  MoveLocationView(
    store: Store(
      initialState: MoveLocationFeature.State(
        userLocation: .init(latitude: 37.5665, longitude: 126.9784)
      ),
      reducer: { MoveLocationFeature() }
    )
  )
}
