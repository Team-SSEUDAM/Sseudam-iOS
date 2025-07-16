//
//  MyPetGrowthListView.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/16/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

public struct BigBottomSheetContentView: View {
  // 샘플 데이터
  
  private let catCards: [CatCard]
  private let growthRecords: [GrowthRecord]
  
  @Binding private var startBottomSheetInsideScroll: Bool
  @Binding private var bottomSheetDragEnabled: Bool
  
  public init(
    catCards: [CatCard],
    growthRecords: [GrowthRecord],
    startBottomSheetInsideScroll: Binding<Bool>,
    bottomSheetDragEnabled: Binding<Bool>
  ) {
    self.catCards = catCards
    self.growthRecords = growthRecords
    self._startBottomSheetInsideScroll = startBottomSheetInsideScroll
    self._bottomSheetDragEnabled = bottomSheetDragEnabled
  }
  
  public var body: some View {
    VStack(alignment: .center) {
      // 고양이 카드 가로 스크롤
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: .Number12) {
          ForEach(catCards) { CatCardCell(card: $0) }
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
      
      BorderView(size: .long)
        .padding(.horizontal, .Number16)
      
      // 성장 기록 섹션 헤더
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
          ForEach(growthRecords) { GrowthRecordCell(record: $0) }
        }
      }
    }
    .padding(.vertical, .Number8)
  }
}
