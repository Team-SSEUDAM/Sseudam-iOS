//
//  SelectPhotoView.swift
//  ReportFeature
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import DesignKit

public struct SelectPhotoView: View {
  @Bindable var store: StoreOf<SelectPhotoFeature>
  
  public init(store: StoreOf<SelectPhotoFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      VStack(alignment: .leading, spacing: .Number24) {
        VStack(alignment: .leading, spacing: .Number8) {
          Text("쓰레기통 사진을 업로드해주세요")
            .font(FontSet.Heading.heading1)
            .foregroundColor(ColorSet.Text.Primary)
          Text("정확한 정보 검증을 위해 사진이 필요해요.")
            .font(FontSet.Body.body3)
            .foregroundColor(ColorSet.Text.Secondary)
        }
        Rectangle()
          .fill(ColorSet.Background.Secondary)
          .aspectRatio(1, contentMode: .fit)
          .clipShape(RoundedRectangle(cornerRadius: .Number16))
          .overlay(
            Icon(
              image: .arrowCircleUp,
              size: .Number64,
              renderingMode: .template
            )
            .foregroundColor(ColorSet.Gray._200)
          )
          .onTapGesture {
            store.send(.centerButtonTapped)
          }
      }
      .padding(.horizontal, .Number16)
      .padding(.vertical, .Number24)
      Spacer()
    }
  }
}
