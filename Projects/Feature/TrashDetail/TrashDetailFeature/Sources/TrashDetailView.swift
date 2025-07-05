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
import TrashSpotDomainInterface

public struct TrashDetailView: View {
  @Bindable var store: StoreOf<TrashDetailFeature>
  
  public init(store: StoreOf<TrashDetailFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
      if store.isEmptyList {
        EmptyDataView
      } else {
        if let data = store.trashDetail {
          DetailContent(data: data)
        } else {
          
        }
      }
    }
  }
  
  @ViewBuilder
  private func DetailContent(data: TrashSpotDetail) -> some View {
    VStack(spacing: .Number16) {
      HStack(spacing: .Number16) {
        VStack(alignment: .leading, spacing: .Number8) {
          TrashLocationView(name: data.name, address: data.address)
          BadgesView(
            trashType: data.trashType.title,
            suggestionName: data.suggestionerName,
            visitedCount: data.visitedCount
          )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
  private var EmptyDataView: some View {
    HStack(alignment: .center) {
      VStack(alignment: .center, spacing: .Number20) {
        Icon(
          image: .sentimentDissatisfied,
          size: .Number32,
          color: ColorSet.Icon.Secondary
        )
        VStack(alignment: .center, spacing: .Number16) {
          Text("이 근방에는 쓰레기통이 없어요.")
            .foregroundStyle(ColorSet.Text.Secondary)
          PrimaryButton(
            title: .constant("제보하러 가기"),
            size: .medium,
            state: .constant(.normal)
          ) {
              print("제보하러 가기")
            }
            .frame(width: 116)
        }
      }
    }
  }
  
  @ViewBuilder
  private func TrashLocationView(name: String, address: String) -> some View {
    VStack(alignment: .leading, spacing: .Number4) {
      Text(name)
        .font(FontSet.Heading.heading3)
        .foregroundStyle(ColorSet.Text.Primary)
      Text(address)
        .font(FontSet.Body.body3)
        .foregroundStyle(ColorSet.Text.Primary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  @ViewBuilder
  private func BadgesView(
    trashType: String,
    suggestionName: String?,
    visitedCount: Int
  ) -> some View {
    HStack(spacing: .Number4) {
      Badge(text: .constant(trashType), state: .primary)
      if let name = suggestionName {
        Badge(text: .constant(name), state: .primary, icon: .verified)
      } else {
        Badge(text: .constant("공공데이터포털"), state: .primary, icon: .verified)
      }
      Badge(text: .constant("인증 \(visitedCount)회"), state: .primary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  @ViewBuilder
  private var ButtonsView: some View {
    HStack(spacing: .Number8) {
      SecondaryButton(title: "수정 제안하기", size: .medium) {
        
      }
      PrimaryButton(
        title: .constant("이 곳에 쓰레기 버리기"),
        size: .medium,
        state: .constant(.normal)
      ) {
        
      }
      .frame(width: 224)
    }
    
    
  }
}


