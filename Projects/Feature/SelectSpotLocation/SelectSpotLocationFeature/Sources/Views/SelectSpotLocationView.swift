//
//  SelectSpotLocationView.swift
//
//  SelectSpotLocation
//
//  Created by yongin
//

import SwiftUI
import Utility
import DesignKit
import ComposableArchitecture

public struct SelectSpotLocationView: View {
  @Bindable var store: StoreOf<SelectSpotLocationFeature>
  
  public init(store: StoreOf<SelectSpotLocationFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      VStack(alignment: .leading, spacing: .Number24) {
        VStack(alignment: .leading, spacing: .Number8) {
          Text("지도를 움직여,\n쓰레기통 위치를 지정해주세요")
            .font(FontSet.Heading.heading1)
            .foregroundStyle(ColorSet.Text.Primary)
            .frame(maxWidth: .infinity, alignment: .leading)
          Text(store.address)
            .font(FontSet.Body.body3)
            .foregroundStyle(ColorSet.Text.Secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(1)
        }
        
        Group {
          SelectSpotMapViewRepresentable(
            userLocation: $store.userLocation
          )
          .onReceive {
            store.send(.centerChanged($0))
          }
          .onMapMovingStarted {
            store.send(.onMapMovingStarted)
          }
          .overlay(
            Icon(
              image: .normalTrashPin,
              size: .Number56
            )
            .offset(y: -16)
            .allowsHitTesting(false),
            alignment: .center
          )
        }
        .aspectRatio(1, contentMode: .fit)
        .clipCorners(.Number10, corners: .allCorners)
        .overlay(
          RoundedRectangle(cornerRadius: .Number10)
            .stroke(ColorSet.Border.Secondary, lineWidth: .Number1)
        )
        
      }
      .onAppear {
        store.send(.onAppear)
      }
      .padding(.horizontal, .Number16)
      .padding(.vertical, .Number24)
      
      Spacer()
    }
  }
}
