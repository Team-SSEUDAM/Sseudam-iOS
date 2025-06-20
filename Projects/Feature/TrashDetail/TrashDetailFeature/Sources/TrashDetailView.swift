//
//  TrashDetailView.swift
//
//  TrashDetail
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture
import DesignKit

public struct TrashDetailView: View {
  @Bindable var store: StoreOf<TrashDetailFeature>
  
  public init(store: StoreOf<TrashDetailFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: .Number16) {
      HStack(spacing: .Number16) {
        VStack(alignment: .leading, spacing: .Number8) {
          TrashLocationView
          BadgesView
        }
        Spacer()
        Rectangle()
          .fill(ColorSet.Background.Secondary)
          .clipShape(RoundedRectangle(cornerRadius: .Number8))
          .frame(width: .Number80, height: .Number80)
      }
      ButtonsView
    }
    .padding(.horizontal, .Number16)
    .padding(.vertical, .Number20)
    
  }
  
  @ViewBuilder
  private var TrashLocationView: some View {
    VStack(alignment: .leading, spacing: .Number4) {
      Text("푸른 수목원")
        .font(FontSet.Heading.heading3)
      Text("서울특별시 구로구 항동 9-1")
        .font(FontSet.Body.body3)
    }
  }
  
  @ViewBuilder
  private var BadgesView: some View {
    HStack(spacing: .Number4) {
      Badge(text: .constant("일반쓰레기"), state: .primary)
      Badge(text: .constant("김지연 제보"), state: .primary, icon: .verified)
      Badge(text: .constant("인증 1회"), state: .primary)
    }
  }
  
  @ViewBuilder
  private var ButtonsView: some View {
    HStack(spacing: .Number8) {
      SecondaryButton(title: "수정 제안하기", size: .medium) {
        
      }
      
      PrimaryButton(title: "이 곳에 쓰레기 버리기", size: .medium, state: .normal) {
        
      }
      .frame(width: 224)
    }
    
    
  }
}


