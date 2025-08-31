//
//  MyPetGrowthListView.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/16/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit

public struct BigBottomSheetContentView: View {
  @Bindable var store: StoreOf<MyPetGrowthListFeature>
  
  @Binding private var startBottomSheetInsideScroll: Bool
  @Binding private var bottomSheetDragEnabled: Bool
  
  public init(
    store: StoreOf<MyPetGrowthListFeature>,
    startBottomSheetInsideScroll: Binding<Bool>,
    bottomSheetDragEnabled: Binding<Bool>
  ) {
    self._startBottomSheetInsideScroll = startBottomSheetInsideScroll
    self._bottomSheetDragEnabled = bottomSheetDragEnabled
    self.store = store
  }
  
  public var body: some View {
    VStack(alignment: .center) {
      if store.catCards.isEmpty == false { 
        SavedCatsView
        BorderView(size: .long).padding(.horizontal, .Number16)
      }
      GrowthRecord
    }
    .padding(.vertical, .Number8)
  }
  
  @ViewBuilder
  private var SavedCatsView: some View {
    VStack(alignment: .leading, spacing: .Number8) {
      HStack(alignment: .center) {
        Text("내가 돌본 고양이")
          .font(FontSet.Body.body3)
          .foregroundStyle(ColorSet.Text.Secondary)
          .padding(.horizontal, .Number16)
        Spacer()
        Icon(
          image: .rightChevron,
          size: .Number24,
          renderingMode: .template,
          color: ColorSet.Icon.Primary
        )
        .padding(.trailing, .Number8)
      }
      .onTapGesture {
        store.send(.delegate(.petDetailButtonTapped))
      }
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: .Number12) {
          ForEach(store.catCards) { CatCardCell(card: $0) }
        }
        .padding(.horizontal, .Number16)
        .padding(.vertical, .Number12)
      }
      .simultaneousGesture(
        DragGesture()
          .onChanged { value in
            if startBottomSheetInsideScroll {
              let horizontalAmount = abs(value.translation.width) > 10 ? abs(value.translation.width) : 0
              let verticalAmount = abs(value.translation.height) > 10 ? abs(value.translation.height) : 0
              bottomSheetDragEnabled = verticalAmount > horizontalAmount
              startBottomSheetInsideScroll = false
            }
          }
          .onEnded { _ in
            startBottomSheetInsideScroll = true
            bottomSheetDragEnabled = true
          }
      )
    }
  }
  
  @ViewBuilder
  private var GrowthRecord: some View {
    HStack(alignment: .center) {
      Text("성장 기록")
        .font(FontSet.Body.body3)
        .foregroundColor(ColorSet.Text.Secondary)
        .padding(.horizontal, .Number16)
      Spacer()
    }
    .padding(.top, .Number8)
    
    // 성장 기록 리스트 (스크롤 가능)
    ScrollView(.vertical, showsIndicators: false) {
      VStack {
        ForEach(store.growthRecords) { GrowthRecordCell(record: $0) }
      }
    }
  }
}
