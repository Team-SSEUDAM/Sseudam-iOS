//
//  TrashThrowConfirmView.swift
//  NotificationFeature
//
//  Created by Jiyeon on 10/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit

public struct TrashThrowConfirmView: View {
  
  @Bindable var store: StoreOf<TrashThrowConfirmFeature>
  
  public init(store: StoreOf<TrashThrowConfirmFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      Spacer()
      VStack(alignment: .center, spacing: .Number16) {
        Image(asset: ImageSet.throwTrash.swiftUIImage)
        Text("\(store.userName)님이 제보한\n쓰레기통에 쓰레기가 버려졌어요!")
          .font(FontSet.Heading.heading1)
          .foregroundStyle(ColorSet.Text.Primary)
          .multilineTextAlignment(.center)
        Text("\(store.userName)님의 제보로 환경 실천이 이어졌어요.\n지금 바로 확인하러 가볼까요?")
          .font(FontSet.Body.body3)
          .foregroundStyle(ColorSet.Text.Secondary)
          .multilineTextAlignment(.center)
      }
      .padding(.horizontal, .Number40)
      Spacer()
      VStack {
        PrimaryButton(
          title: .constant("지금 바로 보러가기"),
          state: .constant(.normal),
          {
            store.send(.showButtonTapped)
          }
        )
        .padding(.Number16)
      }
    }
    
  }
  
  
}
